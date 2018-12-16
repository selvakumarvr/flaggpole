class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.integer :message_type
      t.string :message
      t.datetime :send_at
      t.boolean :tweeted, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :promotions
  end
end
