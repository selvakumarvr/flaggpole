class AlertsController < ApplicationController
  #layout "portal"

  # GET /alerts
  # GET /alerts.xml
  def index
    @alerts = Alert.includes(:infos).order('created_at DESC').paginate(:page => params[:page], :per_page => 25)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @alerts }
    end
  end

  # GET /alerts/1
  # GET /alerts/1.xml
  def show
    @alert = Alert.includes(
      :infos => [
        :event_codes,
        :parameters,
        :resources,
        {:areas => [:geocodes, :circles, :polygons]}
      ] 
    ).find(params[:id])

    respond_to do |format|
      format.html {
        render template: params.include?(:full) ? 'alerts/show_full' : 'alerts/show'
      }
      format.xml  { render :xml => @alert }
    end
  end
end
