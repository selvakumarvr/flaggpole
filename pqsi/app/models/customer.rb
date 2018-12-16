class Customer < ActiveRecord::Base
  has_many :ncms, :dependent => :destroy
  has_many :locations, :dependent => :destroy

  has_many :customer_vendors, :dependent => :destroy
  has_many :vendors, :through => :customer_vendors
  
  has_many :vendored_customers, :class_name => "CustomerVendor", :foreign_key => :vendor_id
  has_many :customers, :through => :vendored_customers
  
  has_many :users, :dependent => :destroy
  
  has_many :jobs, :dependent => :destroy

  def vendor_locations
    vendors.map(&:locations).flatten
  end
  
  validates_presence_of :name
  
  def send_report(start_date, end_date, email)
    ReportMailer.delay.customer_report(self, start_date, end_date, email)
  end

end
