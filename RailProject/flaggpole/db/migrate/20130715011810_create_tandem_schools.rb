class CreateTandemSchools < ActiveRecord::Migration
  def change
    create_table :tandem_schools do |t|
      t.references :district, :null => false
      t.string :nces_id, :null => false
      t.string :name, :null => false
      t.string :yearly_events_url
      t.string :yearly_events_ical
      t.string :yearly_events_xcal
      t.string :events_url
      t.string :events_ical
      t.string :events_xcal

      t.timestamps
    end
    add_index :tandem_schools, :district_id
    add_index :tandem_schools, :nces_id
  end
end
