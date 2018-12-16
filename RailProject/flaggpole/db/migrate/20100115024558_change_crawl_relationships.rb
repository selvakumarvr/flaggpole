class ChangeCrawlRelationships < ActiveRecord::Migration
  def self.up
    remove_column :crawls, :source_id
    remove_column :crawls, :zip
    add_column :crawls, :rss_feed_id, :integer
  end

  def self.down
    remove_column :crawls, :rss_feed_id
    add_column :crawls, :zip, :string
    add_column :crawls, :source_id, :integer
  end
end
