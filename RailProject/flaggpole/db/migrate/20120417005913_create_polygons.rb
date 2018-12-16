class CreatePolygons < ActiveRecord::Migration
  def self.up
    create_table :polygons do |t|
      t.references :area
      t.string :polygon

      t.timestamps
    end
    add_index :polygons, :area_id
  end

  def self.down
    drop_table :polygons
  end
end
