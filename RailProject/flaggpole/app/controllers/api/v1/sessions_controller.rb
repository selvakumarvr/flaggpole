class Api::V1::SessionsController < DeviseController
  before_filter :authenticate_api_user!, :except => [:create]
  before_filter :ensure_params_exist
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    resource = User.find_for_database_authentication(:email => params[:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:password])
      sign_in(:user, resource)
      resource.ensure_authentication_token!
      render :json => {:success => true, :auth_token => resource.authentication_token}
      return
    end
    invalid_login_attempt
  end

  def destroy
    resource = User.find_for_database_authentication(:email => params[:email])
    resource.authentication_token = nil
    resource.save
    render :json => {:success => true}
  end

  protected

  def ensure_params_exist
    return unless params[:email].blank? || params[:password].blank?
    render :json => {:success => false, :message => "Missing email or password parameter"}, :status => :unprocessable_entity
  end

  def invalid_login_attempt
    render :json => {:success => false, :message => "Error with your email or password"}, :status => :unauthorized
  end
end
