class AddDateToTimeEntries < ActiveRecord::Migration
  def self.up
    add_column :time_entries, :date, :date
  end

  def self.down
    remove_column :time_entries, :date
  end
end
