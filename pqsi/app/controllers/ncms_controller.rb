require 'csv'
class NcmsController < ActiveGrid::Controller

  inherit_resources
  before_filter :authenticate_user!

  before_filter :load_scans, :only => [:show, :export, :export_pdf]
  before_filter :load_pareto_chart_data, :only => [:show]
  before_filter :load_locations, :only => [:new, :create, :edit]
  before_filter :load_jobs, :only => [:new, :create,:edit]
  before_filter :collection, :only => [:index, :archived]

  def index

    @ncms = @ncms.active

    @ncms = @ncms.ordered
    # @ncms = collection
    activegrid :ncms, @ncms and return

    respond_to do |format|
      format.html # index.html.erb
      # format.json { render json: @cars }
    end
  end

  def archived
    @ncms = @ncms.archived
    activegrid :ncms, @ncms and return

    respond_to do |format|
      format.html{ render "index" }
    end
  end

  def create
    @ncm = Ncm.new(params[:ncm])

    if @ncm.job_id.blank? && @ncm.description
      @ncm.job = Job.new(:name => @ncm.description)
    end

    @ncm.authorizer = current_user
    if current_user.is_customer?
      @ncm.customer = current_user.customer
    end

    create!

    if current_user.is_pqsi_data_entry? && @ncm.id.present?
      Permission.create(
        :user_id => current_user.id,
        :permissionable_type => 'ncm',
        :permissionable_id => @ncm.id
      )
    end
  end

  def archive
    @ncm = Ncm.find(params[:id])
    if current_user.is_admin? && @ncm.present?
      @ncm.update_attribute(:archive, true)
    end
    redirect_to ncm_path(@ncm)
  end

  def unarchive
    @ncm = Ncm.find(params[:id])
    if current_user.is_admin? && @ncm.present?
      @ncm.update_attribute(:archive, false)
    end
    redirect_to ncm_path(@ncm)
  end

  def new
    @ncm = Ncm.new
    unless current_user.is_customer?
      @ncm.customer = Customer.find(params[:customer_id]) if params[:customer_id]
    end
  end

  def update_hours
    @ncm = Ncm.find(params[:id])
  end

  def delete_all_scans
    @ncm = Ncm.find(params[:id])
    if current_user.is_admin? && @ncm.present?
      @ncm.delay.delete_all_scans
      flash[:notice] = "Scans queued for deletion"
      redirect_to [@ncm, :ncm_data_files]
    end

  end


  def export
    CsvExport.create.delay.start_csv(@ncm, @scans.where_values_hash, current_user, @ncm.report_start_date, @ncm.report_end_date)
    redirect_to params.merge(:controller => "ncms", :action => "show", :id => @ncm.id.to_s), :notice => "Your CSV Export has been queued and will be emailed to you as soon as it's ready."
  end

  def export_pdf
    PdfExport.create.start_pdf(@ncm, @scans.where_values_hash, current_user, @ncm.report_start_date, @ncm.report_end_date)
    redirect_to params.merge(:controller => "ncms", :action => "show", :id => @ncm.id.to_s), :notice => "Your PDF Export has been queued and will be emailed to you as soon as it's ready."
  end

  def destroy
    @ncm = Ncm.find(params[:id])

    authorize! :destroy, @ncm

    @ncm.destroy
    respond_to do |format|
      format.html{ redirect_to ncms_path, :notice => "NCM deleted." }
    end
  end


  private


  def load_locations
    @locations = current_user.authorized_locations
  end


  def load_jobs
    if current_user.is_customer?
      @jobs = current_user.customer.jobs.select("DISTINCT name")
    else
      @jobs = Job.select("DISTINCT name")

    end
  end


  def load_scans

    @ncm = Ncm.find(params[:id])
    @can_edit_ncm = can? :edit, @ncm

    @ncm_params = Ncm.new(params[:ncm])
    @ncm.report_start_date = @ncm_params.report_start_date ? @ncm_params.report_start_date : 30.days.ago.to_date
    @ncm.report_end_date = @ncm_params.report_end_date ? @ncm_params.report_end_date : Date.today


    @scans = @ncm.scans.where(:scanned_on => @ncm.report_start_date..@ncm.report_end_date)

    @lot_number     = params[:lot_number]     if params[:lot_number].present?
    @serial_number  = params[:serial_number]  if params[:serial_number].present?
    @part_number    = params[:part_number]    if params[:part_number].present?
    @reject_reason  = params[:reject_reason]  if params[:reject_reason].present?

    @scans = @scans.where('lot_number like ?', "%#{@lot_number}%") if @lot_number
    @scans = @scans.where('serial like ?', "%#{@serial_number}%") if @serial_number
    @scans = @scans.where('part_number like ?', "%#{@part_number}%") if @part_number
    @scans = @scans.where('(reject_reason_1_label like ? AND reject_reason_1_quantity > 0) OR (reject_reason_2_label like ? AND reject_reason_2_quantity > 0) OR (reject_reason_3_label like ? AND reject_reason_3_quantity > 0) OR (reject_reason_4_label like ? AND reject_reason_4_quantity > 0) OR (reject_reason_5_label like ? AND reject_reason_5_quantity > 0)', "%#{@reject_reason}%", "%#{@reject_reason}%", "%#{@reject_reason}%", "%#{@reject_reason}%", "%#{@reject_reason}%") if @reject_reason

    @total_rejects = 0
    @defect_types = unique_defect_types(@scans)
    @defect_types.each do |defect_type|
      @total_rejects += defect_count(@scans, defect_type) unless @reject_reason.present? && !defect_type.include?(@reject_reason)
    end

    @total_inspected = @scans.sum(:quantity)

    @overall_ppm_rate = 0
    unless @total_inspected == 0 || @total_rejects == 0
      @overall_ppm_rate = (((@total_rejects * 1.0 ) / @total_inspected) * 1000000).round
    end

    @paginated_scans = @scans.paginate(:page => params[:page], :per_page => 100)

  end

  def last_ncm_based_on_job
    @job = Job.find(params[:job_id])
    @last_ncm = @job.ncms.order("created_at desc").first

    respond_to do |format|
      format.json { render :json => @last_ncm }
    end
  end

    def collection
      @ncms = current_user.authorized_ncms.order(:ncm_number)
    end

    def load_pareto_chart_data
      @defect_types = unique_defect_types(@scans)
      @defects = build_list_of_defects(@scans, @defect_types)

      @defect_totals = []
      @defects.each do |defect|
        if @defect_totals.empty?
          @defect_totals << defect["count"] if defect
        else
          @defect_totals << @defect_totals.last + defect["count"] if defect
        end
      end
    end

    def unique_defect_types(scans)
      @scans = scans

      @defect_types = []
      (1..5).each do |i|
        @label = "reject_reason_#{i}_label"
        @scans.select("DISTINCT(#{@label})").map { |l| @defect_types << l.send(@label) }
      end
      @defect_types = @defect_types.uniq.compact
    end


    def build_list_of_defects(scans, defect_types)
      @defects = []

      if @defect_types
        defect_types.each do |defect_type|
          @count = 0
          @count = defect_count(scans, defect_type)
          @defect = nil
          @defect = {"label" => (defect_type.nil? ? "Default" : defect_type ), "count" => @count} unless @count == 0
          @defects << @defect
        end
      end

      @defects.compact
    end

    def defect_count (scans, defect_type)
      @count = 0

      (1..5).each do |i|
        @label = "reject_reason_#{i}_label".to_sym
        @quantity = "reject_reason_#{i}_quantity".to_sym
        @count += scans.where(@label => defect_type).sum(@quantity)
      end

      @count
    end




    def activegrid(name, scope, partial = "#{name}/grid")
      raise "scope must be an ActiveRecord::Relation" unless scope.is_a?(ActiveRecord::Relation)

      if params = self.params[:activegrid] and params[:name] == name.to_s
        scope = scope.order(params[:order]) if params[:order]
        scope = scope.limit(params[:limit]) if params[:limit]
        scope = scope.offset(params[:offset]) if params[:offset]

        logger.debug "filters: #{params[:filter].inspect}"

        if filters = params[:filter]

          logger.debug "filters class #{filters.class.name}"

          case filters[:field]
          when "ncm_number"
            scope = scope.where(['ncm_number LIKE ?', "%" + filters["value"] + "%"])
          when "location"
            unless filters[:value] == "All Locations"
              scope = scope.joins(:location).where(:locations => {:name => filters[:value]})
            end
          when "customer"
            unless filters[:value] == "All Customers"
              scope = scope.joins(:customer).where(:customers => {:name => filters[:value]})
            end
          when "description"
            scope = scope.where(["description LIKE ?", "%" + filters["value"] + "%"])
          when "sqe_pqe"
            scope = scope.where(["sqe_pqe LIKE ?", "%" + filters["value"] + "%"])
          when "mi_name"
            scope = scope.where(["mi_name LIKE ?", "%" + filters["value"] + "%"])
          end

          # table = scope.klass.arel_table
          # scope = scope.where(table[filters[:field]].matches("%#{filters[:value]}%"))
        end

        @element = "#{name}_grid"
        @grid = ActiveGrid::Grid.new(view_context, name, scope, partial)

        respond_to do |format|
          format.js { render "active_grid/update" }
        end

        true
      else
        activegrids[name] = ActiveGrid::Grid.new(view_context, name, scope, partial)
        false
      end
    end

end
