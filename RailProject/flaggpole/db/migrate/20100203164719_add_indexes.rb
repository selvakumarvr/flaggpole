class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :crawls, :rss_feed_id
    add_index :rss_feeds, :twitter_zip_id
    add_index :rss_feeds, :enabled
  end

  def self.down
    remove_index :crawls, :rss_feed_id
    remove_index :rss_feeds, :twitter_zip_id
    remove_index :rss_feeds, :enabled
  end
end
