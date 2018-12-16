class AddUniqueIndexesToTandem < ActiveRecord::Migration
  def up
  	remove_index :tandem_countries, :key
  	add_index :tandem_countries, :key, :unique => true

  	remove_index :tandem_subdivisions, :key
  	add_index :tandem_subdivisions, :key, :unique => true

  	remove_index :tandem_districts, :nces_id
  	add_index :tandem_districts, :nces_id, :unique => true

  	remove_index :tandem_schools, :nces_id
  	add_index :tandem_schools, :nces_id, :unique => true
  end

  def down
  	remove_index :tandem_countries, :key
  	add_index :tandem_countries, :key

  	remove_index :tandem_subdivisions, :key
  	add_index :tandem_subdivisions, :key

  	remove_index :tandem_districts, :nces_id
  	add_index :tandem_districts, :nces_id

  	remove_index :tandem_schools, :nces_id
  	add_index :tandem_schools, :nces_id
  end
end
