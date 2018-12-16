class AddContactEmailToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :contact_email, :string
  end

  def self.down
    remove_column :projects, :contact_email
  end
end
