class AddFilterHashToCsvExports < ActiveRecord::Migration
  def change
    add_column :csv_exports, :filter_hash, :string
  end
end
