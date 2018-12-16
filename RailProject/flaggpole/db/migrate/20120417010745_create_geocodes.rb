class CreateGeocodes < ActiveRecord::Migration
  def self.up
    create_table :geocodes do |t|
      t.references :area, :null => false
      t.string :value_name, :null => false
      t.string :value, :null => false

      t.timestamps
    end
    add_index :geocodes, :area_id
  end

  def self.down
    drop_table :geocodes
  end
end
