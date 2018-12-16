
class NcmPdf < Prawn::Document
  def initialize(ncm, scans_where_values_hash, user, export_start_date, export_end_date)
    super(top_margin: 30)
    super(page_layout: :landscape)
    @date_range = (export_start_date..export_end_date)
    @scans ||= Scan.where(scans_where_values_hash).where(:scanned_on => @date_range).order('id')
    image Rails.root.join("app/assets/images/pqsi-logo-large.png"), :width => 350

    move_down(30)
    add_ncm_details(ncm, export_start_date, export_end_date)
    # start_new_page
    # add_chart
    # start_new_page
    scan_items
    string = "Page <page> of <total>"
    # Green page numbers 1 to 7
    options = { 
      at: [bounds.right - 150, 0],
      width: 150,
      align: :right,
      start_count_at: 1
    }
    number_pages string, options
    
  end

  def add_ncm_details(ncm, export_start_date, export_end_date)

    @total_rejects = 0
    @defect_types = Scan.unique_defect_types(@scans)
    @defect_types.each do |defect_type|
      @total_rejects += Scan.defect_count(@scans, defect_type) unless @reject_reason.present? && !defect_type.include?(@reject_reason)
    end

    @total_inspected = @scans.sum(:quantity)

    @overall_ppm_rate = 0
    unless @total_inspected == 0 || @total_rejects == 0
      @overall_ppm_rate = (((@total_rejects * 1.0 ) / @total_inspected) * 1000000).round
    end

    text "PROJECT: #{ncm.ncm_number} - #{ncm.description}", :size => 24, :style => :bold
    move_down(30)
    text "Defect: #{ncm.description}" if ncm.description.present?
    text "Customer: #{ ncm.customer_name }" if ncm.customer_name.present?
    text "Plant: #{ ncm.plant_name }" if ncm.plant_name.present?
    text "Clipboard: #{ ncm.clipboard }" if ncm.clipboard.present?
    text "SQE / PQE: #{ ncm.sqe_pqe }" if ncm.sqe_pqe.present?
    text "MI Name: #{ ncm.mi_name }" if ncm.mi_name.present?
    text "Instructions: #{ ncm.work_instructions }" if ncm.work_instructions.present?
    text "Clipboard: #{ ncm.clipboard }" if ncm.clipboard.present?
    move_down(20)
    text "Inspected: #{@total_inspected}"
    text "Rejected: #{@total_rejects}"
    text "PPM Rate: #{@overall_ppm_rate}"
    text "First Shift: #{ncm.day_hours(export_start_date, export_end_date).to_s}"
    text "Second Shift: #{ncm.swing_hours(export_start_date, export_end_date).to_s}"
    text "Third Shift: #{ncm.graveyard_hours(export_start_date, export_end_date).to_s}"
    # text "Receiving Hours: #{ncm.receiving_hours(export_start_date, export_end_date).to_s}"

    @defect_types = Scan.unique_defect_types(@scans)
    @defects = Scan.build_list_of_defects(@scans, @defect_types)
    data = @defects.map { |defect| [defect["label"], defect ? defect["count"] : 0] }

    defectchart = Array.new
    lablechart = Array.new
    data.each do |(x, y)|
      defectchart.push y
      lablechart.push x
    end



    move_down(180)

    defects_counts

    move_down(160)

    series = []
    series << Prawn::Graph::Series.new(defectchart,  type: :bar)

    graph series, width: 500, height: 200, at: [10,200], xaxis_labels: lablechart
    move_down(80)

    case ncm.cost_center_type
    when "Cost Center"
      text "Cost Center Name: #{ncm.cost_center_name}"
    when "Supplier"
      text "Supplier Code: #{ncm.supplier_code}"
      text "Supplier Address: #{ncm.supplier_address}, #{ncm.supplier_city}, #{ncm.supplier_state} #{ncm.supplier_zip}"
      text "Supplier Contact: #{ncm.supplier_contact}"
      text "Supplier Phone: #{ncm.supplier_phone}"
    end

  end

  def defects_counts
    @defect_types = Scan.unique_defect_types(@scans)
    @defects = Scan.build_list_of_defects(@scans, @defect_types)
    data = @defects.map { |defect| [defect["label"], defect ? defect["count"] : 0] }

    unless data.empty?
      table_data = [["Defect", "Count"]]
      data.each do |defect|
        table_data << defect
      end
      table table_data
    end
    move_down 300
  end

  def scan_items
    move_down 20
    table scan_item_rows do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
      self.cell_style = { :size => 10 }
      self.column_widths = [45, 45, 65, 60, 67, 65, 75, 40, 40, 100, 118]
      self.cells.border_width = 1
    end
  end

  def scan_item_rows
    [["Data ID", "Row ID", "Inspection Date", "Lot #", "Serial Number", "Mfg. Date", "Part Number", "Inspected", "Rejected", "Rejects Breakdown", "Comment"]] +
    @scans.map do |scan|
      @row = []
      @row << scan.id                       ? scan.id                       : ""
      @row << scan.row_id                   ? scan.row_id                   : ""
      @row << scan.scanned_on               ? scan.scanned_on               : ""
      @row << scan.lot_number               ? scan.lot_number               : ""
      @row << scan.serial                   ? scan.serial                   : ""
      @row << scan.manufacturing_date       ? scan.manufacturing_date       : ""
      @row << scan.part_number              ? scan.part_number              : ""
      @row << scan.quantity                 ? scan.quantity                 : ""
      @row << scan.rejects                  ? scan.rejects                  : ""

      @reject_breakdown = []

      @reject_breakdown << (scan.reject_reason_1_label    ? scan.reject_reason_1_label + ": "    : "")
      @reject_breakdown << (scan.reject_reason_1_quantity ? scan.reject_reason_1_quantity : "")
      @reject_breakdown << "\n" if scan.reject_reason_1_label || scan.reject_reason_1_quantity

      @reject_breakdown << (scan.reject_reason_2_label    ? scan.reject_reason_2_label + ": "    : "")
      @reject_breakdown << scan.reject_reason_2_quantity ? scan.reject_reason_2_quantity : ""
      @reject_breakdown << "\n" if scan.reject_reason_2_label || scan.reject_reason_2_quantity

      @reject_breakdown << (scan.reject_reason_3_label    ? scan.reject_reason_3_label + ": "    : "")
      @reject_breakdown << scan.reject_reason_3_quantity ? scan.reject_reason_3_quantity : ""
      @reject_breakdown << "\n" if scan.reject_reason_3_label || scan.reject_reason_3_quantity

      @reject_breakdown << (scan.reject_reason_4_label    ? scan.reject_reason_4_label + ": "    : "")
      @reject_breakdown << scan.reject_reason_4_quantity ? scan.reject_reason_4_quantity : ""
      @reject_breakdown << "\n" if scan.reject_reason_4_label || scan.reject_reason_4_quantity

      @reject_breakdown << (scan.reject_reason_5_label    ? scan.reject_reason_5_label + ": "    : "")
      @reject_breakdown << scan.reject_reason_5_quantity ? scan.reject_reason_5_quantity : ""

      @row << @reject_breakdown.join(" ")
      # @row << scan.ppm_rate                 ? scan.ppm_rate                 : ""
      @row << scan.comments                 ? scan.comments                 : ""
      @row
    end
  end

  def self.create_test_pdf
    @pe = PdfExport.last
    @ncm = Ncm.find(305)
    @end_date = @ncm.scans.where(:reject_reason_1_quantity == 1).last.created_at
    @start_date = @end_date - 2.days
    @pdf = NcmPdf.new( @ncm, Scan.where(ncm_id: 305).limit(1000).where_values_hash , @pe.user, @start_date, @end_date)
    @pdf.render_file "test.pdf"
  end
end