class AddWorkInstructionsDocumentToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :work_instructions_document, :string
  end

  def self.down
    remove_column :projects, :work_instructions_document
  end
end
