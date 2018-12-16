class AddHoursToNcms < ActiveRecord::Migration
  def self.up
    add_column :ncms, :hours, :float
  end

  def self.down
    remove_column :ncms, :hours
  end
end
