class Admin::LoanFeesController < ApplicationController
  before_action :set_loan_fee, only: [:show, :edit, :update, :destroy]

  def index
    @loan_fees = LoanFee.filter(query_params)
  end

  def show
  end

  def new
    @loan_fee = LoanFee.new
  end

  def create
    @loan_fee = LoanFee.new(loan_fee_params)
    if @loan_fee.save
      flash[:notice] = '创建成功！'
      redirect_to admin_loan_fees_path
    else
      flash.now[:error] = '创建失败！'
      render :new
    end
  end

  def edit

  end

  def update
    if @loan_fee.update(loan_fee_params)
      flash.now[:notice] = '更新成功！'
      redirect_to admin_loan_fees_path
    else
      flash.now[:error] = '更新失败！'
      render :edit
    end
  end

  def destroy
    if @loan_fee.delete
      flash[:notice] = '删除成功！'
    else
      flash[:error] = '删除失败！'
    end
  end

  private

  def set_loan_fee
    @loan_fee ||= LoanFee.find(params[:id])
  end

  def loan_fee_params
    params.require(:loan_fee).permit(:credit_eval_id, :product_id, :times, :management_fee, :dayly_fee, :weekly_fee, :monthly_fee, :active, :user_id)
  end

  def query_params
    params.slice(:times, :period, :score_interval)
  end
end
