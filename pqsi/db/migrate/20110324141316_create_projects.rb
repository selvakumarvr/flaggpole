class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :quantity
      t.integer :authorizer_id
      t.string :vendor_id
      t.string :contact_name
      t.string :contact_phone

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
