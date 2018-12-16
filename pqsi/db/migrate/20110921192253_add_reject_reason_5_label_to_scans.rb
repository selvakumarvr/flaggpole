class AddRejectReason5LabelToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_5_label, :string
  end

  def self.down
    remove_column :scans, :reject_reason_5_label
  end
end
