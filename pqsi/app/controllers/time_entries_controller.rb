class TimeEntriesController < InheritedResources::Base
  
  nested_belongs_to :ncm  
  
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create  
    @notice_msg = "Time entered. Enter another time set or <a href='" + ncm_time_entries_url(params[:ncm_id]) + "'>view the overall hours spent on this NCR</a>"

    @time_entry = TimeEntry.new(params[:time_entry])
    @ncm = Ncm.find(params[:ncm_id].to_i)
    @time_entry.ncm = @ncm
    @time_entry.user = current_user
    
    create!( :notice => @notice_msg ) { [:new, @ncm, :time_entry ] }
    
  end
  

end
