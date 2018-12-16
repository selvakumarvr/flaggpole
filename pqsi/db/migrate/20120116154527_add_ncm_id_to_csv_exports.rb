class AddNcmIdToCsvExports < ActiveRecord::Migration
  def change
    add_column :csv_exports, :ncm_id, :integer
  end
end
