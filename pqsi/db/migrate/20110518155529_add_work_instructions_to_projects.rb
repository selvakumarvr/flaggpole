class AddWorkInstructionsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :work_instructions, :text
  end

  def self.down
    remove_column :projects, :work_instructions
  end
end
