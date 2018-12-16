class AddTwitterFollowersCount < ActiveRecord::Migration
  def self.up
    add_column :twitter_zips, :twitter_followers_count, :integer, :default => 0

    TwitterZip.reset_column_information
    TwitterZip.find(:all).each do |tz|
      TwitterZip.update_counters tz.id, :twitter_followers_count => tz.twitter_followers.length
    end

  end

  def self.down
    remove_column :twitter_zips, :twitter_followers_count
  end
end
