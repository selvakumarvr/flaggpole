class AddAdminToOrganizationUsers < ActiveRecord::Migration
  def change
    add_column :organization_users, :admin, :boolean
  end
end
