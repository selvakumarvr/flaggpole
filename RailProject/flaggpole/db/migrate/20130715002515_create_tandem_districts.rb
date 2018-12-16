class CreateTandemDistricts < ActiveRecord::Migration
  def change
    create_table :tandem_districts do |t|
      t.references :subdivision, :null => false
      t.string :nces_id, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    add_index :tandem_districts, :subdivision_id
    add_index :tandem_districts, :nces_id
  end
end
