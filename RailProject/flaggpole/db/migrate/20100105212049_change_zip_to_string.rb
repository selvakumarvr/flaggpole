class ChangeZipToString < ActiveRecord::Migration
  def self.up
    change_column :twitter_zips, :zip, :string
    change_column :zip_messages, :zip, :string
  end

  def self.down
    change_column :twitter_zips, :zip, :integer
    change_column :zip_messages, :zip, :integer
  end
end
