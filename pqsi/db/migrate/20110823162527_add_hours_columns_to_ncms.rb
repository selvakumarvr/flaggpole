class AddHoursColumnsToNcms < ActiveRecord::Migration
  def self.up
    remove_column :ncms, :hours
    add_column :ncms, :day_hours, :float
    add_column :ncms, :swing_hours, :float
    add_column :ncms, :graveyard_hours, :float
  end

  def self.down
    add_column :ncms, :hours, :float
  end
end
