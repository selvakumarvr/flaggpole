class NcmDataFilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_ncm, :only => [:index, :new, :create]
  
  def index
    @ncm_data_files = @ncm.ncm_data_files.scoped.order(:created_at)
    @ncm_data_files.where(:ncm_data_file_document => nil).delete_all
  end
  
  def new
    @ncm_data_file = NcmDataFile.new
  end
  
  def create
    @ncm_data_file = @ncm.ncm_data_files.new( params[:ncm_data_file] )
    @ncm_data_file.created_by = current_user
    
    if @ncm_data_file.save
      @ncm_data_file.split_file_and_queue_smaller_files
      respond_to do |format|
        format.html { redirect_to [@ncm, :ncm_data_files] }
      end
    end
  end
  
  private
  
  def load_ncm
    @ncm = Ncm.find(params[:ncm_id])
  end
end
