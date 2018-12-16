class RenameLoginToLoginStatus < ActiveRecord::Migration
  def self.up
    rename_column :twitter_zips, :login, :login_status
  end

  def self.down
    rename_column :twitter_zips, :login_status, :login
  end
end
