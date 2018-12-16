class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.references :info
      t.text :area_desc, :null => false
      t.string :altitude
      t.string :ceiling

      t.timestamps
    end
    add_index :areas, :info_id
  end

  def self.down
    drop_table :areas
  end
end
