class CreateNotificationMethodTypes < ActiveRecord::Migration
  def self.up
    create_table :notification_method_types do |t|
      t.string :name
    end
    NotificationMethodType.create(:name => 'Email')
    NotificationMethodType.create(:name => 'Twitter')
    NotificationMethodType.create(:name => 'Facebook')
  end

  def self.down
    drop_table :notification_method_types
  end
end
