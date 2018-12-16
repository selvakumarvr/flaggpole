class Tandem::Subdivision < ActiveRecord::Base
  belongs_to :country, :class_name => "Tandem::Country", :foreign_key => "country_id"
  has_many :districts, :class_name => "Tandem::District", :foreign_key => "subdivision_id"
  attr_accessible :key, :name
end
