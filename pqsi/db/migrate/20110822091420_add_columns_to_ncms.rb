class AddColumnsToNcms < ActiveRecord::Migration
  def self.up
    add_column :ncms, :sqe_pqe, :string
    add_column :ncms, :mi_name, :string
    add_column :ncms, :part_name, :string
    add_column :ncms, :cost_center_type, :string
    add_column :ncms, :cost_center_name, :string
    add_column :ncms, :supplier_name, :string
    add_column :ncms, :supplier_code, :string
    add_column :ncms, :supplier_address, :string
    add_column :ncms, :supplier_city, :string
    add_column :ncms, :supplier_state, :string
    add_column :ncms, :supplier_zip, :string
    add_column :ncms, :supplier_contact, :string
    add_column :ncms, :supplier_phone, :string
  end

  def self.down
    remove_column :ncms, :sqe_pqe
    remove_column :ncms, :mi_name
    remove_column :ncms, :part_name
    remove_column :ncms, :cost_center_type
    remove_column :ncms, :cost_center_name
    remove_column :ncms, :supplier_name
    remove_column :ncms, :supplier_code
    remove_column :ncms, :supplier_address
    remove_column :ncms, :supplier_city
    remove_column :ncms, :supplier_state
    remove_column :ncms, :supplier_zip
    remove_column :ncms, :supplier_contact
    remove_column :ncms, :supplier_phone
  end
end
