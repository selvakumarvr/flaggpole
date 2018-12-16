class AddNcmDataFileToNcms < ActiveRecord::Migration
  def change
    add_column :ncms, :add_ncm_data_file, :string
  end
end
