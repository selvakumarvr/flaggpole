class Api::V1::AlertsController < Api::BaseController
  before_filter :authenticate_api_user!, except: [:show]

  def index
    @alerts = Alert.includes(
      :infos => [
        :event_codes,
        :parameters,
        :resources,
        {:areas => [:geocodes, :circles, :polygons]}
      ]
    ).order("created_at DESC").limit(10)
    #respond_with @alerts.as_json
    #respond_with @alerts
    render json: @alerts, each_serializer: AlertSerializer
  end

  def show
    @alert = Alert.includes(
      :infos => [
        :event_codes,
        :parameters,
        :resources,
        {:areas => [:geocodes, :circles, :polygons]}
      ]
    ).find(params[:id])
    render json: @alert
  end

end
