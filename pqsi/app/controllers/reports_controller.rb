class ReportsController < InheritedResources::Base
  after_filter :get_ncm_and_part, :only => :show
  
  private
  
  def get_ncm_and_part
    begin
      @ncm = Ncm.find(@report.ncm_id)
    rescue ActiveRecord::RecordNotFound
      @ncm = nil
    end
    
    begin
      @part = Ncm.find(@report.part_id)
    rescue ActiveRecord::RecordNotFound
      @part = nil
    end
  end
end
