class Tandem::Country < ActiveRecord::Base
  has_many :subdivisions, :class_name => "Tandem::Subdivision", :foreign_key => "country_id"
  attr_accessible :key, :name
end
