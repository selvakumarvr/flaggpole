require 'csv'

task :export_data => :environment do

  path = "tmp/" 
  filename = 'ncm_' + Date.today.to_s + '.csv'

  scans = Ncm.find(112).scans.order(:row_id)

  CSV.open(path + filename, 'wb' ) do |csv| 
    puts "Starting to export #{ scans.count } scans at #{ Time.now.to_s }"
    @row = ["Scan ID", "Row ID", "Scanned On", "Lot Number", "Serial", "IPN", 
            "Manufacturing Date", "Part Number", "Quantity", "Rejects", 
            "Reject Reason 1", "Reject Reason 1 Quantity", 
            "Reject Reason 2", "Reject Reason 2 Quantity", 
            "Reject Reason 3", "Reject Reason 3 Quantity",
            "Reject Reason 4", "Reject Reason 4 Quantity",
            "Reject Reason 5", "Reject Reason 5 Quantity",
            "PPM Rate", "Comments"]
    csv << @row
    scans.each do |scan|
      @row = []
      @row << scan.id                       ? scan.id                       : ""
      @row << scan.row_id                   ? scan.row_id                   : ""
      @row << scan.scanned_on               ? scan.scanned_on               : ""
      @row << scan.lot_number               ? scan.lot_number               : ""
      @row << scan.serial                   ? scan.serial                   : ""
      @row << scan.ipn                      ? scan.ipn                      : ""
      @row << scan.manufacturing_date       ? scan.manufacturing_date       : ""
      @row << scan.part_number              ? scan.part_number              : ""
      @row << scan.quantity                 ? scan.quantity                 : ""
      @row << scan.rejects                  ? scan.rejects                  : ""
      @row << scan.reject_reason_1_label    ? scan.reject_reason_1_label    : ""
      @row << scan.reject_reason_1_quantity ? scan.reject_reason_1_quantity : ""
      @row << scan.reject_reason_2_label    ? scan.reject_reason_2_label    : ""
      @row << scan.reject_reason_2_quantity ? scan.reject_reason_2_quantity : ""
      @row << scan.reject_reason_3_label    ? scan.reject_reason_3_label    : ""
      @row << scan.reject_reason_3_quantity ? scan.reject_reason_3_quantity : ""
      @row << scan.reject_reason_4_label    ? scan.reject_reason_4_label    : ""
      @row << scan.reject_reason_4_quantity ? scan.reject_reason_4_quantity : ""
      @row << scan.reject_reason_5_label    ? scan.reject_reason_5_label    : ""
      @row << scan.reject_reason_5_quantity ? scan.reject_reason_5_quantity : ""
      @row << scan.ppm_rate                 ? scan.ppm_rate                 : ""
      @row << scan.comments                 ? scan.comments                 : ""
    
      csv << @row
    end
    
    csv_export = CsvExport.new
    csv_export.file = File.open(path + filename)
    csv_export.save!
    puts "Completed scans export at #{ Time.now.to_s }. CSV now downloadable at #{ csv_export.file.url }"
  end

end  
