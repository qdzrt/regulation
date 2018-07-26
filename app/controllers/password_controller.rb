class PasswordController < ApplicationController
  skip_before_action :ensure_sign_in

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(user_params[:email])
    if @user
      UsersMailer.reset_password(@user.id, user_params[:password]).deliver_now
      flash[:notice] = '密码重置邮件已发送，请注意查收'
      redirect_to sign_in_path
    else
      flash[:error] = '该邮箱不存在'
      redirect_to new_password_path
    end
  end

  def edit
    @user = User.new(reset_password_token: params[:token])
  end

  def update
    begin
      payload, header = JsonWebToken.decode(user_params[:reset_password_token])
      @user = User.find(payload['user_id'])
      if @user.update(user_params)
        flash[:notice] = '密码重置成功，请重新登录'
        redirect_to sign_in_path
      else
        flash[:error] = '密码重置失败，请重试'
        redirect_to edit_password_path
      end
    rescue JWT::ExpiredSignature
      flash[:error] = '密码重置链接已经失效，请重新获取'
      redirect_to new_password_path
    rescue JWT::DecodeError
      flash[:error] = '非法操作(token无效)'
      redirect_to sign_in_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end
