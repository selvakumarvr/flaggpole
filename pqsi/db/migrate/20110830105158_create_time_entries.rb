class CreateTimeEntries < ActiveRecord::Migration
  def self.up
    create_table :time_entries do |t|
      t.string :shift
      t.integer :ncm_id
      t.float :hours

      t.timestamps
    end
  end

  def self.down
    drop_table :time_entries
  end
end
