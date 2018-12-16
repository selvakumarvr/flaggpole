class Location < ActiveRecord::Base
  belongs_to :customer
  has_many :ncms
  has_many :permissions, :foreign_key => :object_id
  
  def customer_location
    @name = []
    @name << self.customer.name if self.customer.name && !self.customer.name.blank?
    @name << self.name if self.name && !self.name.blank?
    @name.join(' - ')
  end
  
  def send_daily_report
    if scan_count(Date.yesterday, Date.yesterday) > 0
      ReportMailer.delay.daily_report(self)
    end
  end
  
  def scan_count(start_date = nil, end_date = nil)
    @scope = Scan.joins(:ncm => :location).where('locations.id = ?', self.id)
    @scope = @scope.where(:scanned_on => start_date..end_date) if start_date && end_date
    @scope.count
  end
end
