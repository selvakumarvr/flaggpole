class ChangeLatLngToDecimal < ActiveRecord::Migration
  def self.up
    change_column :places, :lat, :decimal, :precision => 9, :scale => 6
    change_column :places, :lng, :decimal, :precision => 9, :scale => 6
  end

  def self.down
    change_column :places, :lat, :float
    change_column :places, :lng, :float
  end
end
