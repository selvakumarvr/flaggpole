class RemovePlaceIdFromPost < ActiveRecord::Migration
  def self.up
    remove_column :posts, :place_id
  end

  def self.down
    add_column :posts, :place_id, :integer
  end
end
