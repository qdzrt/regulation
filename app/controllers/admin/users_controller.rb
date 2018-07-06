class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :del_images]

  def index
    @users = User.all.with_attached_images
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = '添加成功'
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = '更新成功'
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.delete
      flash[:notice] = '删除成功'
    else
      flash[:error] = '删除失败'
    end
    redirect_to admin_users_path
  end

  def del_images
    if params[:attachment_id]
      @user.images.find(params[:attachment_id]).purge
    elsif params[:purge]
      @user.images.purge_later
    end
    redirect_to admin_users_path
  end

  private

  def set_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :active, images: [], documents: [])
  end
end
