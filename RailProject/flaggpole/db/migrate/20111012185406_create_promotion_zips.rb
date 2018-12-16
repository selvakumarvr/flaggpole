class CreatePromotionZips < ActiveRecord::Migration
  def self.up
    create_table :promotion_zips do |t|
      t.references :promotion
      t.references :twitter_zip
      t.timestamps
    end
    add_index :promotion_zips, :promotion_id
    add_index :promotion_zips, :twitter_zip_id
  end

  def self.down
    drop_table :promotion_zips
  end
end
