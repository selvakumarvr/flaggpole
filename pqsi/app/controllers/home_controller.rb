class HomeController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
        
    @ncms = current_user.authorized_ncms
    
    raise "no authorized ncms" if @ncms.nil?
    
    
    @newest_ncms = @ncms.order("created_at DESC").limit(10)
    @recenlty_update_ncm_ids = Scan.joins(:ncm).where(:ncm_id => @ncms).select('DISTINCT(ncm_id), scanned_on').order("scanned_on DESC").limit(10).map { |scan| scan.ncm_id }
    @recently_updated_ncms = Ncm.where(:id => @recenlty_update_ncm_ids).reverse

    @defects = Ncm.build_list_of_defects(@ncms, 10)
    
  end
  
  def send_reports
    Location.all.each do |location|
      location.send_daily_report
    end
    flash[:notice] = "Report Sending Queued"
    redirect_to root_path
  end
  
end
