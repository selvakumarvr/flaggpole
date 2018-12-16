class AddOrganizationIdToOrganizationUser < ActiveRecord::Migration
  def change
    add_column :organization_users, :organization_id, :integer
    add_index :organization_users, :organization_id
  end
end
