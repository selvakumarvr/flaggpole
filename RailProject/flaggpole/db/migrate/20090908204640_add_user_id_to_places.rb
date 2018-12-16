class AddUserIdToPlaces < ActiveRecord::Migration
  def self.up
  	add_column :places, :user_id, :int 
  end

  def self.down
  	remove_column :places, :user_id
  end
end
