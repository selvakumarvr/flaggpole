class CreateOrganizationMessages < ActiveRecord::Migration
  def change
    create_table :organization_messages do |t|
      t.references :organization
      t.string :message

      t.timestamps
    end
    add_index :organization_messages, :organization_id
  end
end
