class RenameNotificationMethodType < ActiveRecord::Migration
  def self.up
    rename_column :notification_methods, :notification_method_type, :notification_method_type_id
  end

  def self.down
    rename_column :notification_methods, :notification_method_type_id, :notification_method_type
  end
end
