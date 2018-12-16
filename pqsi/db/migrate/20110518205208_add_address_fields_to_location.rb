class AddAddressFieldsToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :address_1, :string
    add_column :locations, :address_2, :string
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :zip, :string
  end

  def self.down
    remove_column :locations, :zip
    remove_column :locations, :state
    remove_column :locations, :city
    remove_column :locations, :address_2
    remove_column :locations, :address_1
  end
end
