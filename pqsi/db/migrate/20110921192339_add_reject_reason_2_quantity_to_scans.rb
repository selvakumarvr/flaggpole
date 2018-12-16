class AddRejectReason2QuantityToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_2_quantity, :integer
  end

  def self.down
    remove_column :scans, :reject_reason_2_quantity
  end
end
