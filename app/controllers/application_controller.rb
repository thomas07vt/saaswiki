class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1 && resource.plan != 0
       # This is the user's first time logging in, so we need to sign them up for stripe.
       subscriptions_finalize_path
    else
       authenticated_root_path
    end
  end

  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to(:back), alert: exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :plan, :stripe_tok) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :plan, :stripe_tok) }
  end

end
