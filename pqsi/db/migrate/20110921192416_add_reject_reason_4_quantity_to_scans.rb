class AddRejectReason4QuantityToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_4_quantity, :integer
  end

  def self.down
    remove_column :scans, :reject_reason_4_quantity
  end
end
