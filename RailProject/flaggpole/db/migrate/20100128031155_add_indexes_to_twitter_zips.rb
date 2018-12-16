class AddIndexesToTwitterZips < ActiveRecord::Migration
  def self.up
    add_index :twitter_zips, :registered
    add_index :twitter_zips, :login
  end

  def self.down
    remove_index :twitter_zips, :registered
    remove_index :twitter_zips, :login
  end
end
