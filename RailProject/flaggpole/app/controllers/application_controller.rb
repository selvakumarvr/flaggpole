class ApplicationController < ActionController::Base
  protect_from_forgery

  def account_url
    return edit_user_registration_path if user_signed_in?
    return admin_root_path if portal_user_signed_in? && current_portal_user.admin?
    return portal_messages_path if portal_user_signed_in?
    return root_path
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || account_url
  end

  def require_admin
   unless current_portal_user && current_portal_user.admin?
     flash[:error] = "Unauthorized access"
     redirect_to new_portal_user_session_path
     false
   end
  end
end
