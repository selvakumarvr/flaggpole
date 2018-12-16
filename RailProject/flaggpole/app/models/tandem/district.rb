class Tandem::District < ActiveRecord::Base
  belongs_to :subdivision, :class_name => "Tandem::Subdivision", :foreign_key => "subdivision_id" 
  has_many :schools, :class_name => "Tandem::School", :foreign_key => "district_id"
  attr_accessible :name, :nces_id
end
