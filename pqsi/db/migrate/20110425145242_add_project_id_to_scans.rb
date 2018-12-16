class AddProjectIdToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :project_id, :integer
  end

  def self.down
    remove_column :scans, :project_id
  end
end
