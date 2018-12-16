class EmailsController < InheritedResources::Base
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  respond_to :html, :only => [:index, :show]
  
  private 
  
  def collection
    @emails = end_of_association_chain.order("created_at desc").paginate(:page => params[:page], :per_page => 20)
  end
end
