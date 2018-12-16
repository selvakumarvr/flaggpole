class AddFipsToTwitterZips < ActiveRecord::Migration
  def self.up
  	add_column :twitter_zips, :county, :string, :after => :city
  	add_column :twitter_zips, :county_fips, :string, :after => :county
  	add_column :twitter_zips, :state_fips, :string, :after => :county_fips
  	add_column :twitter_zips, :same, :string, :after => :state_fips
  	add_index :twitter_zips, :same
  end

  def self.down
  	remove_index :twitter_zips, :same
  	remove_column :twitter_zips, :county
  	remove_column :twitter_zips, :county_fips
  	remove_column :twitter_zips, :state_fips
  	remove_column :twitter_zips, :same
  end
end
