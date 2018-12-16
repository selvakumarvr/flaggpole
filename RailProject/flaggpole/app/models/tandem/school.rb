class Tandem::School < ActiveRecord::Base
  belongs_to :district, :class_name => "Tandem::District", :foreign_key => "district_id"
  has_many :groups, :class_name => "Tandem::Group", :foreign_key => "school_id"
  attr_accessible :events_ical, :events_url, :events_xcal, :name, :nces_id, :yearly_events_ical, :yearly_events_url, :yearly_events_xcal
end
