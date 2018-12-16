class AddNcmNumberToNcms < ActiveRecord::Migration
  def self.up
    add_column :ncms, :ncm_number, :text
  end

  def self.down
    remove_column :ncms, :ncm_number
  end
end
