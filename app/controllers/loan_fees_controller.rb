class LoanFeesController < ApplicationController
  def index
    @loan_fees = LoanFeePreferential.new.call.tap { |loan_fees| SecKill.store(loan_fees) }
  end

  def receive
    member = "loan_fee_#{params[:loan_fee_id]}"
    pre_score = SecKill.score_for member
    SecKill.reduce_for member
    current_score = SecKill.score_for member
    if pre_score > current_score
      flash[:notice] = '领取成功！'
    end
  end

end
