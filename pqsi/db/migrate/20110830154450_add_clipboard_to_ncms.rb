class AddClipboardToNcms < ActiveRecord::Migration
  def self.up
    add_column :ncms, :clipboard, :string
  end

  def self.down
    remove_column :ncms, :clipboard
  end
end
