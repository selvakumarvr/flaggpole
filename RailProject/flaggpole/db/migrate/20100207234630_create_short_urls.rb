class CreateShortUrls < ActiveRecord::Migration
  def self.up
    create_table :short_urls do |t|
      t.text :long_url
      t.text :destination_url
      t.string :hash
      t.integer :count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :short_urls
  end
end
