class Job < ActiveRecord::Base
  has_many :ncms
  belongs_to :customer
end
