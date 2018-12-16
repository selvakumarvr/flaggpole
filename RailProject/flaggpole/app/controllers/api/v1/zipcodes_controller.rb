class Api::V1::ZipcodesController < Api::BaseController
  before_filter :authenticate_api_user!

  def archive
    filename = 'zipcodes.json.gz'
    path = File.join(Rails.public_path, filename)
    if File.exists?(path)
      #hash = Digest::MD5.file(filename).hexdigest
      hash = File.open(path, "rb") { |f| Zlib.crc32 f.read }
      render json: {url: root_url + filename, hash: hash.to_s(16)}
    else
      render json: {errors: 'File not found: ' + filename}, status: :internal_server_error
    end
  end
end
