# frozen_string_literal: true

module SecKill
  extend self

  DATA_HEAD = %w(id times weekly_fee monthly_fee)
  LIST_KEY = 'loan_fees_ids'
  ZSET_KET = 'loan_fees'
  SET_KEY = 'users'

  def store(loan_fees, score = 3)
    return if zset_key_exists? && active_time?
    loan_fees.each do |loan_fee|
      $redis.lpush LIST_KEY, loan_fee[:id]
      DATA_HEAD.each do |field|
        $redis.hset "loan_fee_#{loan_fee[:id]}", field.to_s, loan_fee[field.to_sym]
      end
      $redis.zadd ZSET_KET, score, "loan_fee_#{loan_fee[:id]}"
      # 设置3分钟过期
      $redis.expire ZSET_KET, 60 * 3
    end
  end

  def store_sale(loan_fee_id, user_id)
    $redis.sadd SET_KEY, [loan_fee_id, user_id].join(',')
  end

  def sold
    $redis.smembers SET_KEY
  end

  def special_rates_ids
    $redis.lrange LIST_KEY, 0, -1
  end

  def special_rates
    special_rates_ids.uniq.map(&:to_i).inject([]) do |all, id|
      all << $redis.hgetall("loan_fee_#{id}")
      all
    end
  end

  def score_for(member)
    $redis.zscore ZSET_KET, member
  end

  def reduce_for(member)
    return unless zset_key_exists?
    score = score_for(member) - 1
    $redis.zadd ZSET_KET, score, member
  end

  # TODO true时页面按钮可点
  def zset_key_exists?
    $redis.exists ZSET_KET
  end

  private

  def active_time?
    '2018-07-16 23:40' == Time.current.strftime('%Y-%m-%d %H:%M')
  end
end