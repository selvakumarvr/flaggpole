class CreateSourceTwitterZips < ActiveRecord::Migration
  def self.up
    create_table :source_twitter_zips do |t|
      t.references :source
      t.references :twitter_zip
      t.boolean :enabled
    end
  end

  def self.down
    drop_table :source_twitter_zips
  end
end
