class AddRejectReason1QuantityToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_1_quantity, :integer
  end

  def self.down
    remove_column :scans, :reject_reason_1_quantity
  end
end
