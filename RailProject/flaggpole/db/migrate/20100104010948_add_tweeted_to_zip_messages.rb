class AddTweetedToZipMessages < ActiveRecord::Migration
  def self.up
    add_column :zip_messages, :tweeted, :boolean, :default => 0
  end

  def self.down
    remove_column :zip_messages, :tweeted
  end
end
