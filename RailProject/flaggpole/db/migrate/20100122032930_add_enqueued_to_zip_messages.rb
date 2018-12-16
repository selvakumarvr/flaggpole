class AddEnqueuedToZipMessages < ActiveRecord::Migration
  def self.up
    add_column :zip_messages, :enqueued, :boolean, :default => 0
  end

  def self.down
    remove_column :zip_messages, :enqueued
  end
end
