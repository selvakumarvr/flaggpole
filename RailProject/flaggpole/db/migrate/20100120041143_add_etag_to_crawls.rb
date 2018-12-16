class AddEtagToCrawls < ActiveRecord::Migration
  def self.up
    add_column :crawls, :etag, :string
  end

  def self.down
    remove_column :crawls, :etag
  end
end
