class SeckillService
  include SecKill

  class ExpireError < StandardError; end
  class SoldOutError < StandardError; end

  def initialize(loan_fee_id, user_id)
    @loan_fee_id = loan_fee_id
    @user_id = user_id
  end

  def receive
    if expire?
      raise ExpireError, '活动已过期'
    elsif sold_out?(@loan_fee_id)
      raise SoldOutError, '该优惠费率名额已满'
    else
      pre_score = SecKill.score_for @loan_fee_id
      SecKill.seckill @loan_fee_id, @user_id
      current_score = SecKill.score_for @loan_fee_id
      pre_score > current_score
    end
  end

end