class UsersController < ApplicationController
  skip_before_action :ensure_sign_in

  before_action :set_user, only: [:show, :edit, :update, :del_images]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.active = true
    @user.role_ships.build({role: Role.find_by(code: 'user', name: '普通用户')})
    if @user.save
      sign_in @user
      UsersMailer.create_notify(@user.name, @user.email, user_params[:password]).deliver_now
      flash[:notice] = '注册成功'
      redirect_to after_sign_in_path
    else
      flash[:error] = @user.errors.full_messages.join(',')
      redirect_to sign_up_path
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = '更新成功'
      redirect_to user_path
    else
      render :edit
    end
  end

  def del_images
    if params[:attachment_id]
      @user.images.find(params[:attachment_id]).purge
    elsif params[:purge]
      @user.images.purge_later
    end
    redirect_to user_path
  end

  private

  def set_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms_of_service)
  end
end
