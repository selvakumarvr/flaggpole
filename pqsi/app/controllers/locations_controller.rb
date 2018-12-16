class LocationsController < InheritedResources::Base
  before_filter :authenticate_user!
  
  def create
    @location = Location.new(params[:location])
    
    if current_user.is_customer?
      @location.customer = current_user.customer
    end
    create! { customer_path(@location.customer) }
  end
  
  def new
    @location = Location.new
    @location.customer = Customer.find(params[:customer_id]) if params[:customer_id]
  end
  
  def destroy
    destroy!{ customer_path(@location.customer) }
  end
end
