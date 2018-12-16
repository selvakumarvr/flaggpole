class Ncm < ActiveRecord::Base
  scope :active, where(:archive => false)
  scope :archived, where(:archive => true)
  scope :ordered, -> { includes(:customer).order('customers.name') }

  has_many :csv_exports
  has_many :ncm_data_files
  has_many :pdf_exports
  has_many :permissions, :foreign_key => :permissionable_id, :dependent => :destroy
  has_many :scans, :dependent => :destroy
  has_many :time_entries

  belongs_to :authorizer, :class_name => "User"
  belongs_to :customer
  belongs_to :job
  belongs_to :location


  mount_uploader :work_instructions_document, WorkInstructionsDocumentUploader


  validates :ncm_number, :presence => true

  def active?
    !self.archive
  end

  def archived?
    self.archive
  end

  def customer_name
    @customer_name ||= (self.customer && self.customer.name) ? self.customer.name : ""
  end

  def day_hours(start_date = nil, end_date = nil, type = "inspection")
    self.hours("Day", start_date, end_date, type)
  end

  def defect_count (defect_type, start_date = Date.current - 30.days, end_date = Date.current)
    @count = 0

    (1..5).each do |i|
      @label = "reject_reason_#{i}_label".to_sym
      @quantity = "reject_reason_#{i}_quantity".to_sym
      @count += Scan.where(:scanned_on => start_date..end_date).where(:ncm_id => self.id).where(@label => defect_type).sum(@quantity)
    end

    @count
  end

  def delete_all_scans
    until self.scans.count == 0
      self.scans.limit(1000).delete_all
    end
  end

  def due_for_email_report
    if self.last_report_sent_at.present?
      self.last_report_sent_at <= (Date.yesterday)
    else
      true
    end
  end

  def graveyard_hours(start_date = nil, end_date = nil, type = "inspection")
    self.hours("Graveyard", start_date, end_date, type)
  end

  def hours(shift = nil, start_date = nil, end_date = nil, type)
    @time_entries = self.time_entries
    @time_entries = @time_entries.where(:shift => shift) if shift
    @time_entries = @time_entries.where(:date => start_date..end_date) if start_date && end_date
    @time_entries = @time_entries.where(:entry_type => type)

    @hours = @time_entries.sum(:hours)
    @hours = 0 if @hours.nil?
    ("%.2f" % @hours).to_f
  end

  def label(simple = false)
    if self.ncm_number.blank?
      "NCM " + self.id.to_s
    else
      if simple
        self.ncm_number
      else
        self.ncm_number + " - " + self.description
      end
    end
  end

  def overall_ppm_rate (start_date = Date.current - 30.days, end_date = Date.current, total_rejects, total_inspected)
    @total_rejects = total_rejects
    @total_inspected = total_inspected
    @overall_ppm_rate = 0
    unless @total_inspected == 0 || @total_rejects == 0 || @total_rejects.is_a?(Array)  || @total_inspected.is_a?(Array)
      @overall_ppm_rate = (((@total_rejects * 1.0 ) / @total_inspected) * 1000000).round
    end
  end

  def plant_name
    if self.location && self.location.name
      self.location.name
    elsif self.temporary_location.present?
      self.temporary_location
    else
      "Plant not selected"
    end
  end

  def receiving_hours(start_date = nil, end_date = nil)
    type = "receiving"
    self.hours(nil, start_date, end_date, type)
  end

  def swing_hours(start_date = nil, end_date = nil, type = "inspection")
    self.hours("Swing", start_date, end_date, type)
  end

  def total_inspected(start_date = Date.current - 30.days, end_date = Date.current)
    @scans = self.scans.where(:scanned_on => start_date..end_date)
    @total_inspected = @scans.sum(:quantity)
  end

  def total_inspected_on(inspection_date)
    total_inspected(inspection_date, inspection_date)
  end

  def total_rejects(start_date = Date.current - 30.days, end_date = Date.current)
    @total_rejects = 0
    @defect_types = Ncm.unique_defect_types(self, start_date, end_date)
    if @defect_types
      @defect_types.each do |defect_type|
        @total_rejects += defect_count(defect_type)
      end
    end
    @total_rejects
  end

  # ########################################### #
  # -------- CLASS METHODS START HERE --------- #
  # ########################################### #

  def self.build_list_of_defects(ncms, limit)

    @defect_types = unique_defect_types(ncms)
    @defects = Hash.new

    @grouped_scans = Scan.where(:ncm_id => ncms).where(:scanned_on => 30.days.ago.to_date..Date.today).group(:reject_reason_1_label, :reject_reason_2_label, :reject_reason_3_label, :reject_reason_4_label, :reject_reason_5_label).select("reject_reason_1_label, SUM(reject_reason_1_quantity) as reject_reason_1_quantity, reject_reason_2_label, SUM(reject_reason_2_quantity) as reject_reason_2_quantity, reject_reason_3_label, SUM(reject_reason_3_quantity) as reject_reason_3_quantity, reject_reason_4_label, SUM(reject_reason_4_quantity) as reject_reason_4_quantity, reject_reason_5_label, SUM(reject_reason_5_quantity) as reject_reason_5_quantity")

    @grouped_scans.each do |scan|
      @defects[scan.reject_reason_1_label] ||= 0
      @defects[scan.reject_reason_2_label] ||= 0
      @defects[scan.reject_reason_3_label] ||= 0
      @defects[scan.reject_reason_4_label] ||= 0
      @defects[scan.reject_reason_5_label] ||= 0

      @defects[scan.reject_reason_1_label] += scan.reject_reason_1_quantity if scan.reject_reason_1_quantity
      @defects[scan.reject_reason_2_label] += scan.reject_reason_2_quantity if scan.reject_reason_2_quantity
      @defects[scan.reject_reason_3_label] += scan.reject_reason_3_quantity if scan.reject_reason_3_quantity
      @defects[scan.reject_reason_4_label] += scan.reject_reason_4_quantity if scan.reject_reason_4_quantity
      @defects[scan.reject_reason_5_label] += scan.reject_reason_5_quantity if scan.reject_reason_5_quantity
    end

    @defects = @defects.sort{|a,b| b[1] <=> a[1]}
    @top_defects = top_10_defects(@defects)

  end

  def self.send_daily_mailers
    Rails.logger.info "Ncm.send_daily_mailers"
    ncms_ids_with_scans_created_yesterday = Scan.where('created_at > ? AND created_at < ?', 1.day.ago.beginning_of_day, 1.day.ago.end_of_day).select('DISTINCT ncm_id').map(&:ncm_id)
    @ncms = Ncm.where(id: ncms_ids_with_scans_created_yesterday)
    @ncms.each { |ncm| ReportMailer.delay.daily_report(ncm) }
    Rails.logger.info "Enqueued ReportMailer.daily_report for NCMs: #{ @ncms.map {|ncm| ncm.ncm_number }.join(', ') }"
  end

  def self.top_10_defects(defects)
    @top_defects = Hash.new

    defects.each_with_index do |(key, value), index|
      break if index > 10
      @top_defects[key] = value
    end

    @top_defects
  end

  def self.unique_defect_types(ncms, start_date = Date.current - 30.days, end_date = Date.current)
    @defect_types = []
    (1..5).each do |i|
      @label = "reject_reason_#{i}_label"
      Scan.joins(:ncm).where(:ncm_id => ncms).where(:scanned_on => start_date..end_date).select("DISTINCT(#{@label})").map { |l| @defect_types << l.send(@label) }
    end
    @defect_types = @defect_types.uniq.compact
  end

end