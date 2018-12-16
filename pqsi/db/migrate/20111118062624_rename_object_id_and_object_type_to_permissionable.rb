class RenameObjectIdAndObjectTypeToPermissionable < ActiveRecord::Migration
  def change
    rename_column :permissions, :object_type, :permissionable_type
    rename_column :permissions, :object_id, :permissionable_id
  end
end
