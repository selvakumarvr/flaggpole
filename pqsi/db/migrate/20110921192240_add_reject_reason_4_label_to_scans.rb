class AddRejectReason4LabelToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :reject_reason_4_label, :string
  end

  def self.down
    remove_column :scans, :reject_reason_4_label
  end
end
