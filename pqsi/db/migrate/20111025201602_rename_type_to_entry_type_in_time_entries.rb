class RenameTypeToEntryTypeInTimeEntries < ActiveRecord::Migration
  def up
    rename_column :time_entries, :type, :entry_type
  end

  def down
    rename_column :time_entries, :entry_type, :type
  end
end
