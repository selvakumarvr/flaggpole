class CreateDevices < ActiveRecord::Migration
  def change
  	create_table :devices do |t|
  		t.references :user
  		t.string :token, :null => false
  		t.integer :badge, :null => false, :default => 0
	end
	add_index :devices, :user_id
	add_index :devices, :token, :unique => true
  end
end
