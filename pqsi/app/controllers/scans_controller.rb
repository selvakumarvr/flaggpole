class ScansController < InheritedResources::Base
  
  def index
    redirect_to root_path, :notice => "You are not authorized to view that page."
  end
  
  def new
    @scan = Scan.new
    if params[:ncm_id]
      @ncm = Ncm.find(params[:ncm_id])        
      @scan.ncm = @ncm
    end
  end
  
  def create  
    @notice_msg = "Data entered. Enter another data set or finish entering data and <a href='" + ncm_time_entries_url(params[:scan][:ncm_id]) + "'>enter the hours spent on this NCM for your shift</a>"
    
    create!( :notice => @notice_msg ) do |format| 
      format.html { redirect_to new_scan_path(:ncm_id => @scan.ncm_id ) }  
    end
  end
  
  def update
    update! do |format| 
      format.html { redirect_to ncm_url(@scan.ncm_id) }
    end
  end
  
  def destroy
    
    if current_user.can? :destroy, @scan 
      destroy! do |format| 
        format.html { redirect_to ncm_url(@scan.ncm_id), :notice => "Data was deleted." }
      end
    else
      respond_to do |format|
        format.html { redirect_to ncm_url(@scan.ncm_id), :notice => "You're not authorized to delete this data." }
      end
    end
  end
  
end
