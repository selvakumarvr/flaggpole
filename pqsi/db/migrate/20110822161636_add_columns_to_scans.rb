class AddColumnsToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :lot_number, :string
    add_column :scans, :manufacturing_date, :date
    add_column :scans, :part_number, :string
    add_column :scans, :shift, :string
    add_column :scans, :comments, :text
  end

  def self.down
    remove_column :scans, :lot_number
    remove_column :scans, :manufacturing_date
    remove_column :scans, :part_number
    remove_column :scans, :shift
    remove_column :scans, :comments
  end
end
