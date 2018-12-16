class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.references :info
      t.text :resource_desc, :null => false
      t.text :mime_type, :null => false
      t.integer :size
      t.text :uri
      t.text :deref_uri
      t.text :digest

      t.timestamps
    end
    add_index :resources, :info_id
  end

  def self.down
    drop_table :resources
  end
end
