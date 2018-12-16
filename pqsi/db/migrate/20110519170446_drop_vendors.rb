class DropVendors < ActiveRecord::Migration
  def self.up
    drop_table :vendors
  end

  def self.down
  end
end
