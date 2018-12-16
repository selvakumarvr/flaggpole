class CreateGrouponDivisions < ActiveRecord::Migration
  def self.up
    create_table :groupon_divisions do |t|
      t.string :division_id
      t.string :name
      t.string :timezone
      t.integer :timezone_offset_gmt
      t.integer :msa
      t.string :msa_name
    end
  end

  def self.down
    drop_table :groupon_divisions
  end
end
