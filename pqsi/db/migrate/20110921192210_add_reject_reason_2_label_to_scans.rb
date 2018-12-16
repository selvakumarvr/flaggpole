class AddRejectReason2LabelToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_2_label, :string
  end

  def self.down
    remove_column :scans, :reject_reason_2_label
  end
end
