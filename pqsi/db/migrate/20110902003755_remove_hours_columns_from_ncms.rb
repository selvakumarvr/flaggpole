class RemoveHoursColumnsFromNcms < ActiveRecord::Migration
  def self.up
    remove_column :ncms, :day_hours
    remove_column :ncms, :swing_hours
    remove_column :ncms, :graveyard_hours
  end

  def self.down
  end
end
