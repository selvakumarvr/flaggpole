class AddTimezoneToTwitterZips < ActiveRecord::Migration
  def self.up
    add_column :twitter_zips, :timezone, :integer
    add_index :twitter_zips, :timezone
  end

  def self.down
    remove_index :twitter_zips, :timezone
    remove_column :twitter_zips, :timezone
  end
end
