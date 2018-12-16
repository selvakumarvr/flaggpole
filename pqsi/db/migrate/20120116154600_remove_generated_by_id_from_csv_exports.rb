class RemoveGeneratedByIdFromCsvExports < ActiveRecord::Migration
  def up
    remove_column :csv_exports, :generated_by_id
  end
  
  def down
    add_column :csv_exports, :generated_by_id, :integer
  end

end
