class CreateZipMessages < ActiveRecord::Migration
  def self.up
    create_table :zip_messages do |t|
      t.references :source
      t.integer :zip
      t.string :content
      t.timestamps
    end
    add_index :zip_messages, :zip
    add_index :zip_messages, :source_id
  end

  def self.down
    drop_table :zip_messages
  end
end
