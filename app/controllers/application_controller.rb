class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ensure_sign_in

  def current_user
    @current_user ||= User.find_by(id: [session[:user_id], cookies.signed[:user_id]]) if session[:user_id] || cookies.signed[:user_id]
  end

  def sign_in?
    !!current_user
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
    cookies.delete(:user_id)
  end

  def after_sign_in_path
    home_path
  end

  helper_method :current_user

  private

  def ensure_sign_in
    redirect_to home_path unless sign_in?
  end
end
