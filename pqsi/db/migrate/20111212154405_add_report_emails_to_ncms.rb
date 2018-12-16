class AddReportEmailsToNcms < ActiveRecord::Migration
  def change
    add_column :ncms, :report_emails, :string
  end
end
