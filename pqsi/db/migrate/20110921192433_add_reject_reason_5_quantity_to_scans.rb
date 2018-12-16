class AddRejectReason5QuantityToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_5_quantity, :integer
  end

  def self.down
    remove_column :scans, :reject_reason_5_quantity
  end
end
