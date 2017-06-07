class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :unauthorized

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def unauthorized
    redirect_to sessions_new_path, notice: 'You dont have permission to do '\
      'this.' unless current_user
  end
end
