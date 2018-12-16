class Scan < ActiveRecord::Base
  belongs_to :ncm
  belongs_to :part

  validates_presence_of :ncm_id, :quantity, :scanned_on

  def self.rejects_on(date = nil, ncm = nil, part = nil, start_date = nil, end_date = nil )
    @scans = scoped

    @scans = @scans.where("ncm_id = ?", ncm)                    if ncm
    @scans = @scans.where("part_id = ?", part)                  if part
    @scans = @scans.where("date(scanned_on) = ?", date.to_date) if date

    if start_date && end_date
      @scans = @scans.where("date(scanned_on) >= ?", start_date)
      @scans = @scans.where("date(scanned_on) <= ?", end_date)
    end

    @reject_data = @scans.select(
      "SUM(reject_reason_1_quantity) as reject_reason_1_count,
      SUM(reject_reason_2_quantity) as reject_reason_2_count,
      SUM(reject_reason_3_quantity) as reject_reason_3_count,
      SUM(reject_reason_4_quantity) as reject_reason_4_count,
      SUM(reject_reason_5_quantity) as reject_reason_5_count").first

    @rejects = 0
    @rejects += @reject_data[:reject_reason_1_count].to_i unless @reject_data[:reject_reason_1_count].blank?
    @rejects += @reject_data[:reject_reason_2_count].to_i unless @reject_data[:reject_reason_2_count].blank?
    @rejects += @reject_data[:reject_reason_3_count].to_i unless @reject_data[:reject_reason_3_count].blank?
    @rejects += @reject_data[:reject_reason_4_count].to_i unless @reject_data[:reject_reason_4_count].blank?
    @rejects += @reject_data[:reject_reason_5_count].to_i unless @reject_data[:reject_reason_5_count].blank?
    @rejects

  end

  def self.total_scanned_on(date = nil, ncm = nil, part = nil, start_date = nil, end_date = nil)

    @scans = scoped

    @scans = @scans.where("date(scanned_on) = ?", date.to_date)   if date
    @scans = @scans.where("ncm_id = ?", ncm)                      if ncm
    @scans = @scans.where("part_id = ?", part)                    if part

    if start_date && end_date
      @scans = @scans.where("date(scanned_on) >= ?", start_date)
      @scans = @scans.where("date(scanned_on) <= ?", end_date)
    end

    @scans.sum(:quantity)

  end

  def self.ppm_rate(ncm, part)
    @quantity = total_scanned_on(nil, ncm, part).to_f
    @rejects = rejects_on(nil, ncm, part).to_f

    (@rejects / @quantity * 1000000).to_i
  end

  def rejects
    @rejects = 0
    @rejects += self.reject_reason_1_quantity if self.reject_reason_1_quantity
    @rejects += self.reject_reason_2_quantity if self.reject_reason_2_quantity
    @rejects += self.reject_reason_3_quantity if self.reject_reason_3_quantity
    @rejects += self.reject_reason_4_quantity if self.reject_reason_4_quantity
    @rejects += self.reject_reason_5_quantity if self.reject_reason_5_quantity
    @rejects
  end

  def ppm_rate
    if self.quantity > 0
      @rate = (self.rejects * 1.0 / self.quantity) * 1000000
      @rate = @rate.round
    else
      @rate = nil
    end
    @rate
  end

  def self.unique_defect_types(scans)
    @scans = scans

    @defect_types = []
    (1..5).each do |i|
      @label = "reject_reason_#{i}_label"
      @scans.select("DISTINCT(#{@label}), id").map do |l|
        @new_label = l.send(@label)
        @defect_types << @new_label
      end
    end
    @defect_types = @defect_types.uniq.compact
  end

  def self.build_list_of_defects(scans, defect_types)
    @defects = []

    if @defect_types
      defect_types.each do |defect_type|
        @count = 0
        @count = defect_count(scans, defect_type)
        @defect = nil
        @defect = {"label" => (defect_type.nil? ? "Default" : defect_type ), "count" => @count} unless @count == 0
        @defects << @defect
      end
    end

    @defects.compact
  end

  def self.defect_count (scans, defect_type)
    @count = 0

    (1..5).each do |i|
      @label = "reject_reason_#{i}_label".to_sym
      @quantity = "reject_reason_#{i}_quantity".to_sym
      @count += scans.where(@label => defect_type).sum(@quantity)
    end

    @count
  end

  def self.clean_up_reject_labels
    Scan.scoped.find_in_batches do |batched_scans|
      batched_scans.each do |scan|
        @scan = scan
        (1..5).each do |i|
          @label = "reject_reason_#{i}_label"
          @value = @scan.send(@label)
          # @scan.send(@label, @value) if @value
          if @scan.changed?
            @scan.save
          end
        end
      end
    end
  end
end
