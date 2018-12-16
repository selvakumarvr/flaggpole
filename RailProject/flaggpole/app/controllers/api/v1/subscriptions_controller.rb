class Api::V1::SubscriptionsController < Api::BaseController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_api_user!

  def index
    user = current_api_user
    subscriptions = user.subscriptions.includes(:subscribable)
    render :json => subscriptions
  end

  def create
    user = current_api_user
    subscribable_type, subscribable_id = find_subscribable
    home = params[:home] == 1

    subscription = user.subscriptions.build
    subscription.subscribable_type = subscribable_type
    subscription.subscribable_id = subscribable_id
    subscription.home = home

    if subscription.save
      # set home to false for all subscriptions of this type
      Subscription.remove_home(user, subscribable_type)

      render :json => subscription
    else
      render :json => {:errors => subscription.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def update
    user = current_api_user
    subscription = user.subscriptions.find(params[:id])
    subscribable_type = subscription.subscribable_type
    home = params[:home] == '1'

    result = false
    Subscription.transaction do
      # set home to false for all subscriptions of this type
       Subscription.remove_home(user, subscribable_type)

      # set home to true for this subscription
      result = subscription.update_attributes(home: home)
    end

    if result
      render :json => subscription
    else 
      render :json => {:errors => subscription.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    user = current_api_user
    subscription = user.subscriptions.find(params[:id])
    if subscription.destroy
      render :json => {:success => true}
    else
      render :json => {:errors => subscription.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  private

  # based on http://railscasts.com/episodes/154-polymorphic-association
  def find_subscribable
    organization = params[:organization]
    zip = params[:zip]
    return ['TwitterZip', TwitterZip.find_by_zip(zip).try(:id)] if zip
    return ['Organization', Organization.find_by_id(organization).try(:id)] if organization
    nil
  end

  def find_subscription
    organization = params[:organization]
    zip = params[:zip]
    return TwitterZip.find_by_zip(zip) if zip
    return Organization.find_by_id(organization) if organization
    nil    
  end

end
