class AddTimestampsToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :created_at, :datetime
  	add_column :devices, :updated_at, :datetime
  end
end
