class AddTemporaryLocationToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :temporary_location, :string
  end

  def self.down
    remove_column :projects, :temporary_location
  end
end
