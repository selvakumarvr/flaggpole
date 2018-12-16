class ReportMailer < ActionMailer::Base
  include SendGrid
  sendgrid_enable :opentrack, :clicktrack

  default :from => "PQSI Reports <reports@pqsiinc.com>"

  def daily_report(ncm)
    Rails.logger.info "ReportMailer.daily_report ncm: #{ncm.id}"
    sendgrid_category "Daily Report"

    @ncm  = ncm
    @date = Date.yesterday
    @total_inspected = @ncm.total_inspected(@date, @date)
    @to_recipents = ["reports@pqsiinc.com,jburkette@pqsiinc.com"]
    @to_recipents << @ncm.report_emails if @ncm.report_emails

    @scans = @ncm.scans.where(:scanned_on => @date..@date)

    @total_rejects = 0
    @defect_types = Ncm.unique_defect_types(@ncm)
    @defect_types.each do |defect_type|
      @total_rejects += @ncm.defect_count(defect_type, @date, @date)
    end

    @total_inspected = @scans.sum(:quantity)

    @overall_ppm_rate = 0
    unless @total_inspected == 0 || @total_rejects == 0
      @overall_ppm_rate = (((@total_rejects * 1.0 ) / @total_inspected) * 1000000).round
    end

    mail(:to => @to_recipents.join(','),
         :subject => "PQSI Daily Summary - NCM: #{@ncm.label} for " + @date.strftime("%m/%d/%y") )

    Rails.logger.info "ReportMailer.daily_report ncm: #{ncm.id} sent"
    @ncm.update_attribute(:last_report_sent_at, Date.current)
    Rails.logger.info "Updated last_report_sent_at for ncm #{@ncm.id} to #{Date.current}"

  end

  def customer_report(customer, start_date, end_date, email)
    sendgrid_category "Customer Report"

    @customer = customer
    @locations = @customer.locations
    @start_date = start_date
    @end_date = end_date
    @last_mail_sent = mail(:to => email, :subject => "PQSI Summary Report #{@customer.name} - #{@start_date.strftime("%m/%d/%y")} to #{@end_date.strftime("%m/%d/%y")}")
    Email.log_email(@last_mail_sent)
  end

  def notify_of_csv_export(csv_export, user)
    @csv_export_url = csv_export_url(csv_export)

    mail(:to => user.email,
         :subject => "CSV Export")
  end

  def notify_of_pdf_export(pdf_export, user)
    @pdf_export_url = pdf_export_url(pdf_export)

    mail(:to => user.email,
         :subject => "PDF Export")
  end
end
