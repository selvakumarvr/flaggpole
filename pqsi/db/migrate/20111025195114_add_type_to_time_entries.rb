class AddTypeToTimeEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :type, :string
  end
end
