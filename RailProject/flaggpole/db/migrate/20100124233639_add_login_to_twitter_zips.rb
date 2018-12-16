class AddLoginToTwitterZips < ActiveRecord::Migration
  def self.up
    add_column :twitter_zips, :login, :integer, :default => 1
  end

  def self.down
    remove_column :twitter_zips, :login
  end
end
