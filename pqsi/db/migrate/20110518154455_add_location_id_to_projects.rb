class AddLocationIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :location_id, :integer
  end

  def self.down
    remove_column :projects, :location_id
  end
end
