class CreateTwitterZips < ActiveRecord::Migration
  def self.up
    create_table :twitter_zips do |t|
      t.integer :zip
      t.string :password
    end
    add_index :twitter_zips, :zip
  end

  def self.down
    drop_table :twitter_zips
  end
end
