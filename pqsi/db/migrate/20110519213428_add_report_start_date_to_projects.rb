class AddReportStartDateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :report_start_date, :date
  end

  def self.down
    remove_column :projects, :report_start_date
  end
end
