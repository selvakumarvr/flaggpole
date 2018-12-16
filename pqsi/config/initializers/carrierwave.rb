if Rails.env.production?

  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => 'AKIAINX2GFXLDBJ777NA',       # required
      :aws_secret_access_key  => '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'       # required
      # :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = 'pqsiapp_pro'                     # required
    config.fog_host       = 'https://s3.amazonaws.com'            # optional, defaults to nil
    config.fog_public     = false                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end

elsif Rails.env.development?

  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => 'AKIAINX2GFXLDBJ777NA',       # required
      :aws_secret_access_key  => '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'       # required
      # :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = 'pqsiapp_dev'                     # required
    config.fog_host       = 'https://s3.amazonaws.com'            # optional, defaults to nil
    config.fog_public     = false                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end

end