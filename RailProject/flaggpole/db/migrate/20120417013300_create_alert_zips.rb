class CreateAlertZips < ActiveRecord::Migration
  def self.up
    create_table :alert_zips do |t|
      t.references :alert
      t.references :twitter_zip
      t.timestamps
    end
    add_index :alert_zips, :alert_id
    add_index :alert_zips, :twitter_zip_id
  end

  def self.down
    drop_table :alert_zips
  end
end
