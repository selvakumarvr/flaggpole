class AddReportEndDateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :report_end_date, :date
  end

  def self.down
    remove_column :projects, :report_end_date
  end
end
