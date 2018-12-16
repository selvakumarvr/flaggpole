class AddPopulationEmailRegisteredToTwitterZips < ActiveRecord::Migration
  def self.up
    add_column :twitter_zips, :population, :integer
    add_column :twitter_zips, :email, :string
    add_column :twitter_zips, :registered, :boolean
  end

  def self.down
    remove_column :twitter_zips, :population
    remove_column :twitter_zips, :email
    remove_column :twitter_zips, :registered
  end
end
