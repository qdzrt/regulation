class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user
    if @product.save
      flash[:notice] = '添加成功'
      redirect_to admin_products_path
    else
      flash[:error] = '添加失败'
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = '更新成功'
      redirect_to admin_products_path
    else
      flash[:error] = '更新失败'
      render :edit
    end
  end

  def destroy
    if @product.delete
      flash[:notice] = '删除成功'
    else
      flash[:error] = '删除失败'
    end
    redirect_to admin_products_path
  end

  private

  def set_product
    @product ||= Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :period_num, :period_unit)
  end
end
