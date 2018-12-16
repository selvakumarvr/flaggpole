class AddContactCellToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :contact_cell, :string
  end

  def self.down
    remove_column :projects, :contact_cell
  end
end
