class CreateCustomerVendors < ActiveRecord::Migration
  def self.up
    create_table :customer_vendors do |t|
      t.belongs_to :customer
      t.belongs_to :vendor
      t.timestamps
    end
  end

  def self.down
    drop_table :customer_vendors
  end
end
