class Api::V1::TimelineController < Api::BaseController
  before_filter :authenticate_api_user!

  def index
    # TODO when register also create subscription for ZIP
    subscriptions = current_api_user.subscriptions.includes(:subscribable)
    timeline = Timeline.new subscriptions
    render json: timeline
  end

end
