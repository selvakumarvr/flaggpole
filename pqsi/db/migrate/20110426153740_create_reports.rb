class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.date :start_on
      t.date :end_on
      t.integer :project_id
      t.integer :part_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
