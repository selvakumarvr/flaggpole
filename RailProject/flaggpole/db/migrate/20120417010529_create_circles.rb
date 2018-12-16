class CreateCircles < ActiveRecord::Migration
  def self.up
    create_table :circles do |t|
      t.references :area
      t.string :circle

      t.timestamps
    end
    add_index :circles, :area_id
  end

  def self.down
    drop_table :circles
  end
end
