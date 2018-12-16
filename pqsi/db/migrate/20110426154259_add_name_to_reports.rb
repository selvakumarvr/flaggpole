class AddNameToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :name, :string
  end

  def self.down
    remove_column :reports, :name
  end
end
