class AddCodeToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :code, :string, :after => :addresses
  end

  def self.down
    remove_column :alerts, :code
  end
end
