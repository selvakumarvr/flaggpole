class DropSourceTwitterZips < ActiveRecord::Migration
  def self.up
    drop_table :source_twitter_zips
  end

  def self.down
    create_table :source_twitter_zips do |t|
      t.references :source
      t.references :twitter_zip
      t.boolean :enabled
      t.text :rss_url
    end
  end
end
