class Admin::CreditEvalsController < ApplicationController
  before_action :set_credit_eval, only: [:show, :edit, :update, :destroy]

  def index
    @credit_evals = CreditEval.all
  end

  def show
  end

  def new
    @credit_eval = CreditEval.new
  end

  def create
    @credit_eval = CreditEval.new(credit_eval_params)
    if @credit_eval.save
      flash[:notice] = '创建成功！'
      redirect_to admin_credit_evals_path
    else
      flash[:error] = '创建失败！'
      render :new
    end
  end

  def edit
  end

  def update
    if @credit_eval.update(credit_eval_params)
      flash[:notice] = '更新成功！'
      redirect_to admin_credit_evals_path
    else
      flash[:error] = '更新失败！'
      render :edit
    end
  end

  def destroy
    if @credit_eval.delete
      flash[:notice] = '删除成功！'
    else
      flash[:error] = '删除失败！'
    end
  end

  private

  def set_credit_eval
    @credit_eval ||= CreditEval.find(params[:id])
  end

  def credit_eval_params
    params.require(:credit_eval).permit(:score_gteq, :score_lt, :grade)
  end

  def query_params
    params.slice(:search)
  end

end
