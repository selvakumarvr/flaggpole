class AddMoreIndexesToVariousTables < ActiveRecord::Migration
  def change
    add_index :time_entries, :user_id
    add_index :customer_vendors, [:customer_id, :vendor_id]
    add_index :locations, :customer_id
    add_index :ncms, :customer_id
    add_index :permissions, [:user_id, :permissionable_type, :permissionable_id], :name => "index_permissions_on_user_id_and_p_type_and_p_id"
    add_index :users, :customer_id
    add_index :users, :location_id
    
  end
end
