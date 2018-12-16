class RenameHash < ActiveRecord::Migration
  def self.up
    rename_column :short_urls, :hash, :user_hash
  end

  def self.down
    rename_column :short_urls, :user_hash, :hash
  end
end
