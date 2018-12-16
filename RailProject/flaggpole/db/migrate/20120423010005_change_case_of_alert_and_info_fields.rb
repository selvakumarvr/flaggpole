class ChangeCaseOfAlertAndInfoFields < ActiveRecord::Migration
  def self.up
    rename_column :alerts, :msgType, :msg_type
    rename_column :infos, :senderName, :sender_name
  end

  def self.down
    rename_column :alerts, :msg_type, :msgType
    rename_column :infos, :sender_name, :senderName
  end
end
