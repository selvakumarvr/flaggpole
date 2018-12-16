class ChangeProjectIdColumnsToNcmIdInAssociatedTables < ActiveRecord::Migration
  def self.up
    rename_column :reports, :project_id, :ncm_id
    rename_column :scans, :project_id, :ncm_id
  end

  def self.down
    rename_column :reports, :ncm_id, :project_id
    rename_column :scans, :ncm_id, :project_id
  end
end
