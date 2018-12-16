class RemoveNcmDataFileFromNcms < ActiveRecord::Migration
  def change
    remove_column :ncms, :add_ncm_data_file
  end  
end
