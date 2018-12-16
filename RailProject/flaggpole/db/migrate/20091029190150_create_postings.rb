class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.references :place
      t.references :post
    end
    add_index :postings, :place_id
    add_index :postings, :post_id
  end

  def self.down
    drop_table :postings
  end
end
