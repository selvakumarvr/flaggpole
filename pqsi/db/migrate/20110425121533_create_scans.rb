class CreateScans < ActiveRecord::Migration
  def self.up
    create_table :scans do |t|
      t.integer :part_id
      t.integer :quality
      t.text :description
      t.string :serial
      t.integer :rejects
      t.date :scanned_on

      t.timestamps
    end
  end

  def self.down
    drop_table :scans
  end
end
