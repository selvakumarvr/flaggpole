class AddRejectReason1LabelToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_1_label, :string
  end

  def self.down
    remove_column :scans, :reject_reason_1_label
  end
end
