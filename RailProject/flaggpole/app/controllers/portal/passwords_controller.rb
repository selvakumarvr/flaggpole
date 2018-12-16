class Portal::PasswordsController < Devise::PasswordsController
  private

  def resource_params
    params.require(:portal_user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
