class PartsController < InheritedResources::Base
  before_filter :authenticate_user!
  
  def create
    @all_parts = Part.new(params[:part])
    @all_parts.number.each_line{ |part_number| Part.create(:name => @all_parts.name, :number => part_number)}
    redirect_to parts_path
  end
end
