class CreateRssFeeds < ActiveRecord::Migration
  def self.up
    create_table :rss_feeds do |t|
      t.references :source
      t.references :twitter_zip
      t.text :rss_url
      t.boolean :enabled
    end
  end

  def self.down
    drop_table :rss_feeds
  end
end
