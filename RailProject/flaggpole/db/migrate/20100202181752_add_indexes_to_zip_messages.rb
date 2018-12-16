class AddIndexesToZipMessages < ActiveRecord::Migration
  def self.up
    add_index :zip_messages, :uid
    add_index :zip_messages, :tweeted
    add_index :zip_messages, :enqueued
  end

  def self.down
    remove_index :zip_messages, :uid
    remove_index :zip_messages, :tweeted
    remove_index :zip_messages, :enqueued
  end
end
