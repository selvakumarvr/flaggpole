class AddCreatedByToNcmDataFiles < ActiveRecord::Migration
  def change
    add_column :ncm_data_files, :created_by_id, :integer
  end
end
