class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.references :info
      t.string :value_name, :null => false
      t.string :value, :null => false

      t.timestamps
    end
    add_index :parameters, :info_id
  end

  def self.down
    drop_table :parameters
  end
end
