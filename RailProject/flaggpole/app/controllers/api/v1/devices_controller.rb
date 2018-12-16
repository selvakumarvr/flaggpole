class Api::V1::DevicesController < Api::BaseController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_api_user!

  def index
    user = current_api_user
    devices = user.devices
    render :json => devices
  end

  def create
    user = current_api_user
 
    # un-register the device from the old user if a new user logs in
    existing_device = Device.where(token: params[:token]).first
    existing_device.destory unless existing_device.nil?

    device = user.devices.build
    device.token = params[:token]
    device.badge = params[:badge]

    if device.save
      render :json => device
    else
      render :json => {:errors => device.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def update
    user = current_api_user
    device = user.devices.find(params[:id])
    result = device.update_attributes(device_params)

    if result
      render :json => device
    else 
      render :json => {:errors => device.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    user = current_api_user
    device = user.devices.find(params[:id])
    if device.destroy
      render :json => {:success => true}
    else
      render :json => {:errors => device.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  private

  def device_params
    params.permit(:token, :badge)
  end
end
