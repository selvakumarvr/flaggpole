class RenameProjectsTableToNcms < ActiveRecord::Migration
  def self.up
      rename_table :projects, :ncms
  end 
  def self.down
      rename_table :ncms, :projects
  end
end