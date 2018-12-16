class RenameNotificationEventType < ActiveRecord::Migration
  def self.up
    rename_column :notification_events, :notification_event_type, :notification_event_type_id
  end

  def self.down
    rename_column :notification_events, :notification_event_type_id, :notification_event_type
  end
end
