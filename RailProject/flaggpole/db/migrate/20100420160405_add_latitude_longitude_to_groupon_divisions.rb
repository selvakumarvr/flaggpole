class AddLatitudeLongitudeToGrouponDivisions < ActiveRecord::Migration
  def self.up
    add_column :groupon_divisions, :latitude, :decimal, :precision => 12, :scale => 6
    add_column :groupon_divisions, :longitude, :decimal, :precision => 12, :scale => 6
  end

  def self.down
    remove_column :groupon_divisions, :latitude
    remove_column :groupon_divisions, :longitude
  end
end
