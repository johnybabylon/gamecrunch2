class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_devise_parameters, if: :devise_controller?

  protected
  def configure_devise_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:team, :league, :phone, :email, :password, :password_confirmation, :current_password)
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || welcome_index_path
  end

  def after_update_path_for(resource)
    welcome_index_path(resource)
  end

end
