class AddOauthToTwitterZips < ActiveRecord::Migration
  def self.up
    add_column :twitter_zips, :oauth_token, :string
    add_column :twitter_zips, :oauth_secret, :string
  end

  def self.down
    remove_column :twitter_zips, :oauth_token
    remove_column :twitter_zips, :oauth_secret
  end
end
