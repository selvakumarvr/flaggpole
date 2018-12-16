class AddColsToTwitterZips < ActiveRecord::Migration
  def self.up
    add_column :twitter_zips, :latitude, :decimal, :precision => 12, :scale => 6
    add_column :twitter_zips, :longitude, :decimal, :precision => 12, :scale => 6
    add_column :twitter_zips, :state, :string
    add_column :twitter_zips, :city, :string
    add_column :twitter_zips, :msa, :integer
    add_column :twitter_zips, :msa_name, :string
  end

  def self.down
    remove_column :twitter_zips, :latitude
    remove_column :twitter_zips, :longitude
    remove_column :twitter_zips, :state
    remove_column :twitter_zips, :city
    remove_column :twitter_zips, :msa
    remove_column :twitter_zips, :msa_name
  end
end
