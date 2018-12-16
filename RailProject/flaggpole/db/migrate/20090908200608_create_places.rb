class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :name
      t.int :user_id
      t.float :lat
      t.float :lng
      t.timestamps
    end
  end
  
  def self.down
    drop_table :places
  end
end
