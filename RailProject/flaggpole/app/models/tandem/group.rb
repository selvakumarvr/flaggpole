class Tandem::Group < ActiveRecord::Base
  belongs_to :school, :class_name => "Tandem::School", :foreign_key => "school_id"
  attr_accessible :events_ical, :events_url, :events_xcal, :key, :name
end
