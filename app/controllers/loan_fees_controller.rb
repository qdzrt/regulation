class LoanFeesController < ApplicationController
  def index
    @loan_fees = LoanFeePreferential.new.call
    @loan_fees.each do |loan_fee|
      $redis.lpush 'loan_fees_ids', loan_fee.id
      $redis.hset "loan_fee_#{loan_fee.id}", 'loan_fee_id', loan_fee.loan_fee_id
      $redis.hset "loan_fee_#{loan_fee.id}", 'loan_fee_times', loan_fee.times
      $redis.hset "loan_fee_#{loan_fee.id}", 'loan_fee_weekly_fee', loan_fee.weekly_fee
      $redis.hset "loan_fee_#{loan_fee.id}", 'loan_fee_monthly_fee', loan_fee.monthly_fee
      $redis.zadd "loan_fees", 3, "loan_fee_#{loan_fee.id}"
      $redis.expire "loan_fees", 60 * 3
    end
  end

  def receive

  end
end
