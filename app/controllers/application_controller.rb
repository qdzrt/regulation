class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :ensure_sign_in
  after_action :store_location
  include Pundit

  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

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
    session[:previous_url] = nil
    session[:user_id] = nil
    cookies.delete(:user_id)
  end

  def after_sign_in_path
    default_path = if current_user.admin?
                      admin_products_path
                    elsif current_user.user?
                      admin_roles_path
                    else
                      root_path
                    end
    session[:previous_url] || default_path
  end

  def store_location
    return unless request.get?
    if request.path != sign_in_path && request.path != not_found_path && request.xhr?
      session[:previous_url] = request.fullpath
    end
  end

  def previous_url
    session[:previous_url]
  end

  helper_method :current_user
  helper_method :previous_url

  private

  def ensure_sign_in
    unless sign_in?
      flash.now[:warning] = "请先登录"
      redirect_to root_path
    end
  end

  def user_not_authorized
    flash[:warning] = "无权限访问"
    redirect_to(request.referrer || root_path)
  end

  def not_found
    logger.error 'Routing error occurred'
    # render plain: '404 Not found', status: 404
    respond_to do |format|
      format.html { render template: 'welcome/not_found', status: 404 }
      format.json { render json: { errors: APIErrors.wrap(exception) } , status: 404 }
      format.js { render partial: 'errors/ajax_404', status: 404 }
    end
  end

end
