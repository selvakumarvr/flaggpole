class CustomersController < InheritedResources::Base
  before_filter :authenticate_user!
  
  def select_vendors
    @customer = Customer.find(params[:id])
    @customers = Customer.all
  end
  
  def assign_vendor
    @customer = Customer.find(params[:id])
    @vendor = Customer.find(params[:vendor_id])
    
    @customer.vendors << @vendor
    
    redirect_to customer_path(@customer)
  end
  
  def summary_report
    @customer = Customer.where(:id => params[:id]).first
    @start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i) if params[:start_date]
    @start_date ||= last_week_start_date
    @end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i) if params[:end_date]
    @end_date ||= last_week_end_date
    
    @email = params[:email] if params[:email]
    @email ||= "mr@webdesigncompany.net, info@pqsiinc.com"
    
    if request.post?
      if @customer.delay.send_report(@start_date, @end_date, @email)
        flash.now[:notice] = "Your report has been queued and will be emailed to you once it's ready."
      end
    end
  end
  
  private
  
  def last_week
    @last_week ||= Date.current - 1.week
  end
  
  def last_week_start_date
    Date.commercial(last_week.year, last_week.cweek, 1)
  end
    
  def last_week_end_date
    Date.commercial(last_week.year, last_week.cweek, 7)
  end
  
  def collection
    @customers ||= end_of_association_chain.order(:name)
  end
end
