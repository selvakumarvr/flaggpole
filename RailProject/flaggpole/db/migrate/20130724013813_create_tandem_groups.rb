class CreateTandemGroups < ActiveRecord::Migration
  def change
    create_table :tandem_groups do |t|
      t.references :school, :null => false
      t.string :key, :null => false
      t.string :name, :null => false
      t.string :events_url
      t.string :events_ical
      t.string :events_xcal

      t.timestamps
    end
    add_index :tandem_groups, :school_id
    add_index :tandem_groups, :key
  end
end
