class CreateGrouponZips < ActiveRecord::Migration
  def self.up
    create_table :groupon_zips do |t|
      t.references :groupon_division
      t.references :twitter_zip
    end
    add_index :groupon_zips, :groupon_division_id
    add_index :groupon_zips, :twitter_zip_id
  end

  def self.down
    drop_table :groupon_zips
  end
end
