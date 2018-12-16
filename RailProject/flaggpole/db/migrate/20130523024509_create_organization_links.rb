class CreateOrganizationLinks < ActiveRecord::Migration
  def change
    create_table :organization_links do |t|
      t.references :organization
      t.string :name
      t.string :url

      t.timestamps
    end
    add_index :organization_links, :organization_id
  end
end
