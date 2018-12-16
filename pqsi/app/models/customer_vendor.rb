class CustomerVendor < ActiveRecord::Base
  belongs_to :customer
  belongs_to :vendor, :class_name => "Customer"
  has_many :locations, :through => :customer
end
