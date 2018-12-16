class AddRejectReason3LabelToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_3_label, :string
  end

  def self.down
    remove_column :scans, :reject_reason_3_label
  end
end
