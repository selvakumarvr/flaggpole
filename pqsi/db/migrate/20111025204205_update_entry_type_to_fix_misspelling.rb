class UpdateEntryTypeToFixMisspelling < ActiveRecord::Migration
  def up
    TimeEntry.where(:entry_type => "recieving").update_all(:entry_type => "receiving")
  end

  def down
    TimeEntry.where(:entry_type => "receiving").update_all(:entry_type => "recieving")
  end
end
