class AddSavedRowInfoToNcmDataFiles < ActiveRecord::Migration
  def change
    add_column :ncm_data_files, :existing_rows, :text
    add_column :ncm_data_files, :existing_row_count, :integer
    add_column :ncm_data_files, :error_rows, :text
    add_column :ncm_data_files, :error_row_count, :integer
    add_column :ncm_data_files, :saved_rows, :text
    add_column :ncm_data_files, :saved_row_count, :integer
  end
end
