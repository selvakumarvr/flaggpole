class AddLastReportSentAtToNcms < ActiveRecord::Migration
  def change
    add_column :ncms, :last_report_sent_at, :date
  end
end
