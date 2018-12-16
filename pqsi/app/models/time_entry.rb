class TimeEntry < ActiveRecord::Base
  belongs_to :ncm
  belongs_to :user
  
  validates_presence_of :date, :shift, :hours
end
