class AddStatusToNcmDataFiles < ActiveRecord::Migration
  def change
    add_column :ncm_data_files, :status, :string
  end
end
