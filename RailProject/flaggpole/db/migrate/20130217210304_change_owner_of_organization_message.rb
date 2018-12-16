class ChangeOwnerOfOrganizationMessage < ActiveRecord::Migration
  def up
  	remove_index :organization_messages, :organization_id
  	remove_column :organization_messages, :organization_id

  	add_column :organization_messages, :organization_user_id, :integer
  	add_index :organization_messages, :organization_user_id
  end

  def down
  	add_column :organization_messages, :organization_id, :integer
  	add_index :organization_messages, :organization_id

	remove_index :organization_messages, :organization_user_id
  	remove_column :organization_messages, :organization_user_id
  end
end
