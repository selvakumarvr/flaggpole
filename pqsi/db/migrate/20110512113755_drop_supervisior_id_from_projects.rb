class DropSupervisiorIdFromProjects < ActiveRecord::Migration
  def self.up
    remove_column :projects, :supervisior_id
  end

  def self.down
    add_column :projects, :supervisior_id, :integer
  end
end
