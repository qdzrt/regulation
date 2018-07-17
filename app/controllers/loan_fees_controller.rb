class LoanFeesController < ApplicationController
  def index
    @loan_fees = LoanFeePreferential.new.call.tap { |loan_fees| SecKill.store(loan_fees) }
  end

  def seckill
    loan_fee_id = params[:loan_fee_id]
    user_id = current_user.id
    status = SeckillService.new(loan_fee_id, user_id).receive
    if status
      render json: {success: true, message: '领取成功！'}
    else
      render json: {success: false, message: '领取失败！'}
    end
  rescue => e
    render json: {success: false, message: e.message}
  end

end
