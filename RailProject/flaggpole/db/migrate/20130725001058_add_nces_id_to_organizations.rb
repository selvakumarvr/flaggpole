class AddNcesIdToOrganizations < ActiveRecord::Migration
  def change
  	add_column :organizations, :nces_id, :string
  	add_index :organizations, :nces_id
  end
end
