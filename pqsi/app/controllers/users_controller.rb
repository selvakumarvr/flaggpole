class UsersController < InheritedResources::Base
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def create
    @user = User.new(params[:user])
    if current_user.is_customer?
      @ncm.customer = current_user.customer
    end    
    create!{ users_path }
  end
  
  def new
    @user = User.new
    unless current_user.is_customer?
      @user.customer = Customer.find(params[:customer_id]) if params[:customer_id]
    end
  end
  
  def add_permission
    @user = User.find(params[:id])
    @permissionable_type = params[:permissionable_type]
    @permissionable_id = params[:permissionable_id].to_i
    if current_user.is_master_admin? || current_user.is_volcanic?
      Permission.create(:user_id => @user.id, 
                        :permissionable_type => @permissionable_type, 
                        :permissionable_id => @permissionable_id)
    end
    redirect_to user_path(@user)
  end
  
  def remove_permission
    @user = User.find(params[:id])
    @permission = @user.permissions.find(params[:permission_id])
    if current_user.is_master_admin? || current_user.is_volcanic?
      @permission.destroy
    end
    redirect_to user_path(@user)
  end
  
  
  private
  
    def collection
      if current_user.is_customer?
        @users = current_user.customer.users
      end
    end
end
