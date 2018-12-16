class Portal::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication
  before_filter :require_admin, :only => [:new, :create, :destroy]

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  protected

  def sign_up(resource_name, resource)
    # noop
  end

  def after_sign_up_path_for(resource)
    admin_root_path
  end

  private

  def resource_params
    permitted = [:email, :password, :password_confirmation, :remember_me, :current_password]
    permitted << :organization_id if current_portal_user && current_portal_user.admin?
    params.require(:portal_user).permit(*permitted)
  end
end
