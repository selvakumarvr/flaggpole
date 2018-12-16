class TwitterZipsController < ApplicationController
  def index
    @tzs = TwitterZip.registered.can_login.select([:city,:state,:zip]).all(:conditions => ['zip LIKE ?', "#{params[:q]}%"],  :limit => 20, :order => 'zip')
    
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render :json => @tzs }
    end
  end
  
  def followers_count
    tz = TwitterZip.find_by_zip params[:id]
    @followers_count = tz.try(:followers_count) || 0
    respond_to do |format|
      format.json { render :json => @followers_count }
    end
  end
  
end
