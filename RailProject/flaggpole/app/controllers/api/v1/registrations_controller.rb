class Api::V1::RegistrationsController < Api::BaseController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_api_user!, :only => [:update]

  def create
    user = User.new(user_params)
    if user.save
      # automatically subscribe them to TwitterZip if exists
      user.subscribe_to_zip(user.zip)

      render :json => user.as_json(:auth_token => user.authentication_token, :email => user.email), :status => :created
    else
      warden.custom_failure!
      render :json => {:errors => user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def update
    user = User.find_for_token_authentication(params)
    if user.update_attributes({zip: params[:zip]})
      user.subscribe_to_zip(params[:zip])
      render :json => user.as_json
    else
      warden.custom_failure!
      render :json => {:errors => user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  protected
  def user_params
    {email: params[:email], password: params[:password], zip: params[:zip]}
  end

end
