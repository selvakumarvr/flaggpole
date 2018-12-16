class RenameQualityToQuantityInScans < ActiveRecord::Migration
  def self.up
    rename_column :scans, :quality, :quantity
  end

  def self.down
    rename_column :scans, :quantity, :quality
  end
end
