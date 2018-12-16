class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  
  before_filter :ensure_domain
  
  # before_filter :lock_out_everyone_except_volcanic

    APP_DOMAIN = 'www.pqsiapp.com'
    APP_STAGING_DOMAIN = "dev.pqsiapp.com"

    def ensure_domain
      if request.env['HTTP_HOST'] != APP_DOMAIN && request.env['HTTP_HOST'] != APP_STAGING_DOMAIN && Rails.env == "production" 
        # HTTP 301 is a "permanent" redirect
        redirect_to "http://#{APP_DOMAIN}", :status => 301
      end
    end
    
    def lock_out_everyone_except_volcanic
      if user_signed_in? && !(current_user.is_volcanic?)
        render :text => "We're currently upgrading the PQSI Quality Manager. Please check back shortly."
      end
    end
  
end
