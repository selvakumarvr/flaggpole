class AddRssUrlToSourceTwitterZips < ActiveRecord::Migration
  def self.up
    add_column :source_twitter_zips, :rss_url, :text
  end

  def self.down
    remove_column :source_twitter_zips, :rss_url
  end
end
