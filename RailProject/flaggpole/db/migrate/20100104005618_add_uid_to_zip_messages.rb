class AddUidToZipMessages < ActiveRecord::Migration
  def self.up
    add_column :zip_messages, :uid, :string
  end

  def self.down
    remove_column :zip_messages, :uid
  end
end
