class AddIndexScreenName < ActiveRecord::Migration
  def self.up
    add_index :twitter_followers, :screen_name
  end

  def self.down
    remove_index :twitter_followers, :screen_name
  end
end
