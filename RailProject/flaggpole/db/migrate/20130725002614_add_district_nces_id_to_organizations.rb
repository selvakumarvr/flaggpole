class AddDistrictNcesIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :district_nces_id, :string
    add_index :organizations, :district_nces_id
  end
end
