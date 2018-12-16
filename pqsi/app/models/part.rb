class Part < ActiveRecord::Base
  has_many :scans
  
  def number_name
    number + " - " + name
  end
end
