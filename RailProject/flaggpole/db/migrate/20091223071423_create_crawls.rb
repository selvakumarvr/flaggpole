class CreateCrawls < ActiveRecord::Migration
  def self.up
    create_table :crawls do |t|
      t.references :source
      t.integer :zip
      t.integer :message_count
      t.timestamps
    end
  end

  def self.down
    drop_table :crawls
  end
end
