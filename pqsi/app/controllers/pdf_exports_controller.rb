class PdfExportsController < InheritedResources::Base
  load_and_authorize_resource

  def show
    if @pdf_export.file
      redirect_to @pdf_export.file.url
    else
      redirect_to pdf_exports_url, :notice => "Something went wrong in exporting this PDF file. Please try again."
    end
  end

end
