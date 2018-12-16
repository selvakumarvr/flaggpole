class OrganizationLink < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :name, :url
  validates_presence_of :name, :url
end
