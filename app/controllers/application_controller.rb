class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :ensure_sign_in

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  def current_user
    user_id = session[:user_id] || cookies.signed[:user_id]
    @current_user ||= User.find(user_id) if user_id
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
    if current_user.admin?
      admin_products_path
    elsif current_user.user?
      admin_roles_path
    else
      home_path
    end
  end

  helper_method :current_user

  private

  def ensure_sign_in
    redirect_to home_path unless sign_in?
  end

  def user_not_authorized
    flash[:warning] = "无权限访问"
    redirect_to(request.referrer || root_path)
  end
end
