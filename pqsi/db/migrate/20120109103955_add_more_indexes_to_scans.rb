class AddMoreIndexesToScans < ActiveRecord::Migration
  def change
    add_index :scans, [:ncm_id, :row_id]
  end
end
