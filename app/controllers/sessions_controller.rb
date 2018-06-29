class SessionsController < ApplicationController
  skip_before_action :ensure_sign_in
  skip_before_action :verify_authenticity_token

  def new
    @user = User.new
  end

  def create
    user = User.authorize!(user_params)
    if user.try(:active)
      sign_in user
      if params[:remember_me]
        cookies.signed[:user_id] = {value: user.id, expiry: 60.days}
      else
        cookies.delete(:user_id)
      end
      redirect_to after_sign_in_path
    else
      if user
        flash[:notice] = '用户未激活'
      else
        flash[:error] = '邮箱或密码错误'
      end
      redirect_to sign_in_path
    end
  end

  def destroy
    sign_out
    flash.now[:notice] = '您已安全退出'
    redirect_to sign_in_path
  end

  private

  def user_params
    params.permit(:email, :password, :remember_me)
  end
end
