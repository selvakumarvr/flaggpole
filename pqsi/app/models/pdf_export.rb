class PdfExport < ActiveRecord::Base
  belongs_to :ncm
  belongs_to :user

  mount_uploader :file, PdfFileUploader


  def start_pdf(ncm, scans_where_values_hash, user, export_start_date, export_end_date)
    @date_range = (export_start_date..export_end_date)
    @scans_scope = Scan.where(scans_where_values_hash).where(:scanned_on => @date_range).order('id')
    @total_count = @scans_scope.count
    self.save
    puts "Scan count #{ @total_count }"
    path = "#{Rails.root}/tmp/"
    filename = self.id.to_s + '-ncm-' + ncm.ncm_number.parameterize + '-from-' + export_start_date.to_s + '-to-' + export_end_date.to_s + '-exported-'+ Time.zone.now.strftime("%Y%m%d%H%M%S") + '.pdf'

    full_filename = path + filename

    pdf = NcmPdf.new(ncm, scans_where_values_hash, user, export_start_date, export_end_date)
    pdf.render_file full_filename

    self.file = File.open(full_filename)
    self.user = user
    self.ncm = ncm
    self.filter_hash = scans_where_values_hash.merge("scanned_on" => @date_range).to_s

    if self.save && !self.file.nil?
      self.notify_user
    else
      raise Exception
    end
    puts "Completed scans export at #{ Time.now.to_s }. PFD now downloadable at #{ self.file.url }"
  end

  def notify_user
    ReportMailer.delay.notify_of_pdf_export(self, self.user)
  end
end
