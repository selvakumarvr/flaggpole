class AddRejectReason3QuantityToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_3_quantity, :integer
  end

  def self.down
    remove_column :scans, :reject_reason_3_quantity
  end
end
