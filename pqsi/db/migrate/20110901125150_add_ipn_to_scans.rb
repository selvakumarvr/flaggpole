class AddIpnToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :ipn, :string
  end

  def self.down
    remove_column :scans, :ipn
  end
end
