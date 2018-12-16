class OrganizationMessage < ActiveRecord::Base
  belongs_to :author, :class_name => 'OrganizationUser', :foreign_key => :organization_user_id
  attr_accessible :message

  validates :message, :presence => true, :length => { :maximum => 140 }
end
