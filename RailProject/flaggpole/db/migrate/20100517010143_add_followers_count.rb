class AddFollowersCount < ActiveRecord::Migration
  def self.up
  	add_column :twitter_zips, :followers_count, :integer
  end

  def self.down
  	remove_column :twitter_zips, :followers_count
  end
end
