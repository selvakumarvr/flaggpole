class AddIndexesToScans < ActiveRecord::Migration
  def change
    add_index :scans, :ncm_id
  end
end
