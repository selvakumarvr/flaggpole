class CreateNotificationEvents < ActiveRecord::Migration
  def self.up
    create_table :notification_events do |t|
      t.references :user
      t.integer :notification_event_type
    end
    add_index :notification_events, :user_id
  end

  def self.down
    drop_table :notification_events
  end
end
