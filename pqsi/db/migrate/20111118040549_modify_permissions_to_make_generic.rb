class ModifyPermissionsToMakeGeneric < ActiveRecord::Migration
  def change
    rename_column :permissions, :ncm_id, :object_id
    add_column :permissions, :object_type, :string
  end
end
