class CreateTwitterMentions < ActiveRecord::Migration
  def self.up
    create_table :twitter_mentions do |t|
      t.references :twitter_zip
      t.integer :mention_id, :limit => 8
      t.datetime :mention_created_at
      t.string :text
      t.string :source
      t.integer :user_id
      t.string :user_screen_name
      t.integer :user_followers_count
      t.integer :user_friends_count
      t.datetime :user_created_at
      t.integer :user_statuses_count
      t.boolean :following
    end
    add_index :twitter_mentions, :mention_id
  end

  def self.down
    drop_table :twitter_mentions
  end
end
