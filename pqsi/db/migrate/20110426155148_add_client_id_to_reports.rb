class AddClientIdToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :client_id, :integer
  end

  def self.down
    remove_column :reports, :client_id
  end
end
