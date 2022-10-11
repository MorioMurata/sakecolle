class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin!, if: :admin_url
  before_action :authenticate_user!, if: :public_url

  def admin_url
    request.fullpath.include?("/admin")
  end

  def public_url
    request.path.include?("/public")
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
