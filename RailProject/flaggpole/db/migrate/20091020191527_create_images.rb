class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.references :post
      t.timestamps
    end
    add_index :images, :post_id
  end

  def self.down
    drop_table :images
  end
end
