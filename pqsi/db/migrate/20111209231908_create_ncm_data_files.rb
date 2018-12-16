class CreateNcmDataFiles < ActiveRecord::Migration
  def change
    create_table :ncm_data_files do |t|
      t.string "ncm_data_file_document"
      t.integer "ncm_id"
      t.timestamps
    end
  end
end
