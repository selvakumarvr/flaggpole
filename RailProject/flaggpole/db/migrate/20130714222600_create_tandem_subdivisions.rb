class CreateTandemSubdivisions < ActiveRecord::Migration
  def change
    create_table :tandem_subdivisions do |t|
      t.references :country, :null => false
      t.string :key, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    add_index :tandem_subdivisions, :country_id
    add_index :tandem_subdivisions, :key
  end
end
