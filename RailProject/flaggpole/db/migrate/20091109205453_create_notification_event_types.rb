class CreateNotificationEventTypes < ActiveRecord::Migration
  def self.up
    create_table :notification_event_types do |t|
      t.string :name
    end
    NotificationEventType.create(:name => "Someone comments on my post")
    NotificationEventType.create(:name => "Others comment on a post I've commented")
    NotificationEventType.create(:name => "Someone posts to a flaggpole I'm following")
    NotificationEventType.create(:name => "A new flaggpole is added in my area")
  end

  def self.down
    drop_table :notification_event_types
  end
end
