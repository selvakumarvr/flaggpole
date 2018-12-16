class CreateTwitterFollowers < ActiveRecord::Migration
  def self.up
    create_table :twitter_followers do |t|
      t.references :twitter_zip
      t.string :name
      t.string :screen_name
      t.string :location
      t.string :description
      t.string :url
      t.integer :followers_count
      t.integer :friends_count
      t.boolean :following
    end
  end

  def self.down
    drop_table :twitter_followers
  end
end
