class AddIndexesToShortUrls < ActiveRecord::Migration
  def self.up
    add_column :short_urls, :long_url_sha1, :string
    add_index :short_urls, :long_url_sha1, :unique => true
    add_index :short_urls, :user_hash
  end

  def self.down
    remove_index :short_urls, :long_url_sha1
    remove_index :short_urls, :user_hash
    remove_column :short_urls, :long_url_sha1
  end
end
