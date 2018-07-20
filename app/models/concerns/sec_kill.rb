# frozen_string_literal: true

#TODO 同步数据到数据库
module SecKill
  extend self

  DATA_HEAD = %w(id times weekly_fee monthly_fee)
  LIST_KEY = 'loan_fees_ids'
  ZSET_KET = 'loan_fees'
  SET_KEY = 'users'

  def seckill(loan_fee_id, user_id)
    return if receive?(loan_fee_id, user_id)
    store_sale(loan_fee_id, user_id)
    decrement_for(loan_fee_id)
  end

  def store(loan_fees, score = 3)
    loan_fees.each do |loan_fee|
      loan_fee_id = loan_fee[:id]
      store_rates_list(loan_fee_id)
      store_rates_detail(loan_fee, loan_fee_id)
      store_rates_stock(loan_fee_id, score)
      # 设置半小时后过期
      $redis.expire ZSET_KET, 60 * 30
    end
  end

  def store_rates_list(loan_fee_id)
    $redis.lpush LIST_KEY, loan_fee_id
  end

  def store_rates_detail(loan_fee, loan_fee_id)
    DATA_HEAD.each do |field|
      $redis.hset member(loan_fee_id), field.to_s, loan_fee[field.to_sym]
    end
  end

  def store_rates_stock(loan_fee_id, score)
    $redis.zadd ZSET_KET, score, member(loan_fee_id)
  end

  def store_sale(loan_fee_id, user_id)
    $redis.sadd SET_KEY, set_member(loan_fee_id, user_id)
  end

  def decrement_for(loan_fee_id)
    return if finish?(loan_fee_id)
    $redis.zincrby ZSET_KET, -1, member(loan_fee_id)
  end

  def fetch_sold
    $redis.smembers SET_KEY
  end

  def fetch_rates_ids
    $redis.lrange(LIST_KEY, 0, -1).uniq.map(&:to_i)
  end

  def fetch_rates
    fetch_rates_ids.inject([]) do |all, id|
      all << $redis.hgetall(member(id))
      all
    end
  end

  def score_for(loan_fee_id)
    $redis.zscore(ZSET_KET, member(loan_fee_id)).to_i
  end

  # 是否过期
  def not_expire?
    $redis.exists ZSET_KET
  end

  def expire?
    !not_expire?
  end

  # 是否售罄
  def sold_out?(loan_fee_id)
    score_for(loan_fee_id) == 0
  end

  # 是否领取过
  def receive?(loan_fee_id, user_id)
    $redis.sismember SET_KEY, set_member(loan_fee_id, user_id)
  end

  def finish?(loan_fee_id)
    sold_out?(loan_fee_id) || expire?
  end

  def clean_cache
    $redis.del LIST_KEY
    $redis.del SET_KEY
    keys = $redis.keys 'loan_fee_id:*'
    $redis.del *keys
  end

  def member(loan_fee_id)
    ['loan_fee_id', ':', loan_fee_id].join
  end

  def set_member(loan_fee_id, user_id)
    [loan_fee_id, user_id].join('-')
  end
end