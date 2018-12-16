class Permission < ActiveRecord::Base
  belongs_to :user
  # belongs_to :object
  
  scope :location_permissions, where(:permissionable_type =>  "location")
  scope :ncm_permissions, where(:permissionable_type =>  "ncm")
  
  def self.permissionable_ids(permissions)
    permissions.map{ |p| p.permissionable_id }
  end
  
end
