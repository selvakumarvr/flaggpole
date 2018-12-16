class CsvExportsController < InheritedResources::Base
  load_and_authorize_resource
  
  def show
    if @csv_export.file
      redirect_to @csv_export.file.url
    else
      redirect_to csv_exports_url, :notice => "Something went wrong in exporting this CSV file. Please try again."
    end
  end

end
