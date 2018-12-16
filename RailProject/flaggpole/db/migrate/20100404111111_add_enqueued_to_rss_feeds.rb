class AddEnqueuedToRssFeeds < ActiveRecord::Migration
  def self.up
    add_column :rss_feeds, :enqueued, :boolean, :default => 0
    add_index :rss_feeds, :enqueued
  end

  def self.down
    remove_index :rss_feeds, :enqueued
    remove_column :rss_feeds, :enqueued
  end
end
