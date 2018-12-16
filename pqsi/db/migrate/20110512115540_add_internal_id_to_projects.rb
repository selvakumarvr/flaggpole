class AddInternalIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :internal_id, :integer
  end

  def self.down
    remove_column :projects, :internal_id
  end
end
