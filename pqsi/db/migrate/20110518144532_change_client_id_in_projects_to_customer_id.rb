class ChangeClientIdInProjectsToCustomerId < ActiveRecord::Migration
  def self.up
    rename_column :projects, :client_id, :customer_id
  end

  def self.down
    rename_column :projects, :customer_id, :client_id
  end
end
