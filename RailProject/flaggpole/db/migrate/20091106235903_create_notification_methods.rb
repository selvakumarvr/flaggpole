class CreateNotificationMethods < ActiveRecord::Migration
  def self.up
    create_table :notification_methods do |t|
      t.references :user
      t.integer :notification_method_type
    end
    add_index :notification_methods, :user_id
  end

  def self.down
    drop_table :notification_methods
  end
end
