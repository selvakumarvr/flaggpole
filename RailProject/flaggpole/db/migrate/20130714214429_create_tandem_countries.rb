class CreateTandemCountries < ActiveRecord::Migration
  def change
    create_table :tandem_countries do |t|
      t.string :key
      t.string :name

      t.timestamps
    end
    add_index :tandem_countries, :key
  end
end
