class AddSupervisiorIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :supervisior_id, :integer
  end

  def self.down
    remove_column :projects, :supervisior_id
  end
end
