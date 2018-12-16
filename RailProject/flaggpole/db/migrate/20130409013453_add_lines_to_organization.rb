class AddLinesToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :line1, :string
    add_column :organizations, :line2, :string
  end
end
