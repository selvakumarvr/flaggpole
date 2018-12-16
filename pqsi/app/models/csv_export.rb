class CsvExport < ActiveRecord::Base
  
  belongs_to :ncm
  belongs_to :user
  
  mount_uploader :file, CsvFileUploader
  
  
  def start_csv(ncm, scans_where_values_hash, user, export_start_date, export_end_date)
    @date_range = (export_start_date..export_end_date)
    @scans_scope = Scan.where(scans_where_values_hash).where(:scanned_on => @date_range).order('id')
    @total_count = @scans_scope.count
    self.save
    puts "Scan count #{ @total_count }"
    path = "#{Rails.root}/tmp/" 
    filename = self.id.to_s + '-ncm-' + ncm.ncm_number.parameterize + '-from-' + export_start_date.to_s + '-to-' + export_end_date.to_s + '-exported-'+ Time.zone.now.strftime("%Y%m%d%H%M%S") + '.csv'

    full_filename = path + filename

    puts "full_filename"
    puts full_filename

    @csv_file = CSV.open(full_filename, 'wb' ) do |csv|
      puts "Starting to export #{ @total_count } scans at #{ Time.now.to_s }"
      @row = ["Scan ID", "Row ID", "Scanned On", "Lot Number", "Serial", "IPN", 
              "Manufacturing Date", "Part Number", "Quantity", "Rejects", 
              "Reject Reason 1", "Reject Reason 1 Quantity", 
              "Reject Reason 2", "Reject Reason 2 Quantity", 
              "Reject Reason 3", "Reject Reason 3 Quantity",
              "Reject Reason 4", "Reject Reason 4 Quantity",
              "Reject Reason 5", "Reject Reason 5 Quantity",
              "PPM Rate", "Comments"]
      csv << @row

      total_loops = (@total_count / 1000) + 1

      total_loops.times do |n|

        @scans = @scans_scope.offset(n * 1000).limit(1000)

        @scans.each do |scan|
          @row = []
          @row << scan.id                       ? scan.id                       : ""
          @row << scan.row_id                   ? scan.row_id                   : ""
          @row << scan.scanned_on               ? scan.scanned_on               : ""
          @row << scan.lot_number               ? scan.lot_number               : ""
          @row << scan.serial                   ? scan.serial                   : ""
          @row << scan.ipn                      ? scan.ipn                      : ""
          @row << scan.manufacturing_date       ? scan.manufacturing_date       : ""
          @row << scan.part_number              ? scan.part_number              : ""
          @row << scan.quantity                 ? scan.quantity                 : ""
          @row << scan.rejects                  ? scan.rejects                  : ""
          @row << scan.reject_reason_1_label    ? scan.reject_reason_1_label    : ""
          @row << scan.reject_reason_1_quantity ? scan.reject_reason_1_quantity : ""
          @row << scan.reject_reason_2_label    ? scan.reject_reason_2_label    : ""
          @row << scan.reject_reason_2_quantity ? scan.reject_reason_2_quantity : ""
          @row << scan.reject_reason_3_label    ? scan.reject_reason_3_label    : ""
          @row << scan.reject_reason_3_quantity ? scan.reject_reason_3_quantity : ""
          @row << scan.reject_reason_4_label    ? scan.reject_reason_4_label    : ""
          @row << scan.reject_reason_4_quantity ? scan.reject_reason_4_quantity : ""
          @row << scan.reject_reason_5_label    ? scan.reject_reason_5_label    : ""
          @row << scan.reject_reason_5_quantity ? scan.reject_reason_5_quantity : ""
          @row << scan.ppm_rate                 ? scan.ppm_rate                 : ""
          @row << scan.comments                 ? scan.comments                 : ""

          csv << @row        
        end

        puts "Finished with row #{ ((n+1) * 1000) }"
      end
    end

    self.file = File.open(full_filename)
    self.user = user
    self.ncm = ncm
    self.filter_hash = scans_where_values_hash.merge("scanned_on" => @date_range).to_s
    
    if self.save && !self.file.nil?
      self.notify_user
    else
      raise Exception
    end
    puts "Completed scans export at #{ Time.now.to_s }. CSV now downloadable at #{ self.file.url }"
  end
  
  def notify_user
    ReportMailer.delay.notify_of_csv_export(self, self.user)
  end
end
