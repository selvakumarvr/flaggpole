require 'csv'

class NcmDataFile < ActiveRecord::Base
  belongs_to :ncm
  belongs_to :created_by, :class_name => "User"

  mount_uploader :ncm_data_file_document, NcmDataFileUploader

  def split_file_and_queue_smaller_files
      original_data = HTTParty.get(self.ncm_data_file_document.url)
      original = Rails.root + "/tmp/#{self.id}-#{File.basename(self.ncm_data_file_document.to_s).gsub(/\?.*/, '')}".to_s
      original_file = File.new( original, 'w+' )
      original_file.write original_data
      original_file.close
      lines_per_file = 1000

      header_lines = 1
      lines = `cat #{original} | wc -l`.to_i - header_lines
      file_count = (lines / lines_per_file) + 1
      total_lines_per_file = 1000 + header_lines
      header = `head -n #{header_lines} #{original}`

      start = header_lines
      generated_files = []

      file_count.times do |i|
        finish = start + total_lines_per_file
        file = "#{original}-#{i}.csv"

        File.open(file,'w'){|f| f.write header }
        sh "tail -n #{lines - start} #{original} | head -n #{total_lines_per_file} >> #{file}"

        start = finish
        generated_files << file

        current_ncm_data_file = NcmDataFile.create(:ncm_id => self.ncm_id)
        current_ncm_data_file.ncm_data_file_document = File.open(file)
        current_ncm_data_file.update_attribute(:created_by, self.created_by)
        current_ncm_data_file.queue_file_for_processing
      end

      generated_files
  end

  def queue_file_for_processing
    self.update_attribute(:status, 'Uploaded')
    self.process_file
    self.update_attribute(:status, 'Queued')
  end

  def original_file
    original_filename
  end

  def process_file
    ability = Ability.new(self.created_by)
    if ability.can?(:create, Scan)
      # puts "csv file found in parameters"
      Scan.transaction do
        # puts "Starting Scan importing"
        @csv_data = HTTParty.get(self.ncm_data_file_document.url)

        self.import_csv(@csv_data)
      end
    end
  end

  def import_csv(csv_data)
    update_status('Processing')
    reset_counts_and_row_ids

    @csv = CSV.parse(csv_data, :headers => :first_row)

    @csv.each do |row|

      begin
        if scan_exists?(row["Row ID"], self.ncm_id)
          record_existing_row(row["Row ID"])
        else
          process_row(row)
        end
      rescue Exception => e
        record_error_row(row["Row ID"], e.message)
      end

    end

    logger.info "done with importing"
    update_status('Processed') unless self.status.present? && self.status.include?("Errors On Import")
  end

  # private

  def scan_exists?(row_id, ncm_id)
    Scan.where(:row_id => row_id, :ncm_id => ncm_id).count > 0
  end

  def process_row(row)
    # puts "Building scan object"
    @scan             = Scan.new
    @scan.row_id      = row["Row ID"]
    @scan.lot_number  = row["Lot Number"]
    @scan.serial      = row["Serial Number"]
    @scan.ipn         = row["IPN"]
    @scan.ncm_id      = self.ncm_id
    @scan.part_number = row["Part Number"]

    if row["Manufacturing Date"]
      @manufacturing_date = Date.strptime(row["Manufacturing Date"], '%m/%d/%Y')
      @manufacturing_date = @manufacturing_date + 2000.years if @manufacturing_date < (Date.today - 1000.years)
      @scan.manufacturing_date  = @manufacturing_date
    end

    if row["Inspection Date"]
      @scanned_on_date  = Date.strptime(row["Inspection Date"], '%m/%d/%Y')
      @scanned_on_date  = @scanned_on_date + 2000.years if @scanned_on_date < (Date.today - 1000.years)
      @scan.scanned_on  = @scanned_on_date
    end

    @scan.quantity    = row["Quantity"]
    @scan.comments    = row["Comments"]

    @headers = row.headers.find_all{|header| header =~ /^Reject:\s*/ }
    @headers.each_with_index do |header, index|

      next if header.gsub(/^Reject:\s*/, '').blank?

      if index == 0
        @scan.reject_reason_1_label = header.gsub(/^Reject:\s*/, '')
        @scan.reject_reason_1_quantity = row[header]
      elsif index == 1
        @scan.reject_reason_2_label = header.gsub(/^Reject:\s*/, '')
        @scan.reject_reason_2_quantity = row[header]
      elsif index == 2
        @scan.reject_reason_3_label = header.gsub(/^Reject:\s*/, '')
        @scan.reject_reason_3_quantity = row[header]
      elsif index == 3
        @scan.reject_reason_4_label = header.gsub(/^Reject:\s*/, '')
        @scan.reject_reason_4_quantity = row[header]
      elsif index == 4
        @scan.reject_reason_5_label = header.gsub(/^Reject:\s*/, '')
        @scan.reject_reason_5_quantity = row[header]
      end

    end

    if @scan.valid?
      if @scan.save
        record_saved_row(row["Row ID"])
      end
    else
      puts @errors = @scan.errors.full_messages
      record_error_row(row["Row ID"], @errors)
    end
  end

  def reset_counts_and_row_ids
    self.update_attribute(:existing_rows, "")
    self.update_attribute(:saved_rows, "")
    self.update_attribute(:error_rows, "")
    self.update_attribute(:saved_row_count, 0)
    self.update_attribute(:error_row_count, 0)
    self.update_attribute(:existing_row_count, 0)
  end

  def record_existing_row(row_id)
    # self.update_attribute(:existing_rows, [self.existing_rows, row_id].join(','))
    self.update_attribute(:existing_row_count, self.existing_row_count ? (self.existing_row_count + 1) : 1)
  end

  def record_saved_row(row_id)
    # self.update_attribute(:saved_rows, [self.saved_rows, row_id].join(','))
    self.update_attribute(:saved_row_count, self.saved_row_count ? (self.saved_row_count + 1) : 1)
  end

  def record_error_row(row_id, new_error_messages = nil)
    # self.update_attribute(:error_rows, [self.error_rows, row_id].join(','))
    self.update_attribute(:error_row_count, self.error_row_count ? (self.error_row_count + 1) : 1)

    if self.status.present? && self.status.include?("Errors On Import")

      new_status = self.status

      if new_error_messages.present? && !(self.status.include?(new_error_messages))
        new_status = new_status + ", #{new_error_messages.to_s}"
      else

      end

    else
      new_status = "Errors On Import"
      new_status +=  ": " + new_error_messages.to_s if new_error_messages.present?
    end

    update_status new_status
    logger.info "Completed recording error row #{ row_id }"
  end

  def update_status(status)
    self.update_attribute(:status, status)
  end
end
