class CreateEventCodes < ActiveRecord::Migration
  def self.up
    create_table :event_codes do |t|
      t.references :info
      t.string :value_name, :null => false
      t.string :value, :null => false

      t.timestamps
    end
    add_index :event_codes, :info_id
  end

  def self.down
    drop_table :event_codes
  end
end
