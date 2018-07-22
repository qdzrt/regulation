class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :del_images]

  def index
    page = params[:page] || 1
    per = params[:per] || 30
    @users = User.includes(:roles).filter(query_params).with_attached_images.page(page).per(per)
    authorize @users
  end

  def show
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      UsersMailer.create_notify(@user.name, @user.email, user_params[:password]).deliver_now
      flash.now[:notice] = '添加成功'
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      flash.now[:notice] = '更新成功'
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    authorize @user
    if @user.delete
      flash.now[:notice] = '删除成功'
    else
      flash.now[:error] = '删除失败'
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :active, role_ids: [], images: [], documents: [])
  end

  def query_params
    params.slice(:search)
  end
end
