class AddCjLinkToGrouponDivision < ActiveRecord::Migration
  def self.up
    add_column :groupon_divisions, :cj_link, :text
    add_index :groupon_divisions, :division_id
  end

  def self.down
    remove_column :groupon_divisions, :cj_link
    remove_index :groupon_divisions, :division_id
  end
end
