class AddIndexesForTwitterZipId < ActiveRecord::Migration
  def self.up
    add_index :twitter_followers, :twitter_zip_id
    add_index :twitter_mentions, :twitter_zip_id
  end

  def self.down
    remove_index :twitter_followers, :twitter_zip_id
    remove_index :twitter_mentions, :twitter_zip_id
  end
end
