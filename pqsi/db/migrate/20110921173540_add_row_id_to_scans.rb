class AddRowIdToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :row_id, :string
  end

  def self.down
    remove_column :scans, :row_id
  end
end
