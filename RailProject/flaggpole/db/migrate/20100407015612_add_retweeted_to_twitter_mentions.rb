class AddRetweetedToTwitterMentions < ActiveRecord::Migration
  def self.up
    add_column :twitter_mentions, :retweeted, :boolean
  end

  def self.down
    remove_column :twitter_mentions, :retweeted
  end
end
