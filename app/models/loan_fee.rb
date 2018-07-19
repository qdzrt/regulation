class LoanFee < ApplicationRecord
  include Filterable

  TIMES = {
    '首贷' => 1,
    '续贷' => 2
  }

  belongs_to :credit_eval
  belongs_to :product
  belongs_to :user

  validates_with LoanFeeUniqValidator
  validates_with LoanFeeActiveConflictValidator

  delegate :name, to: :user, prefix: true
  delegate :name, to: :product, prefix: true
  delegate :score_interval, to: :credit_eval, prefix: false

  scope :asc, ->(column){order(column)}
  scope :desc, ->(column){order("#{column.to_s} DESC")}

  scope :times, ->(times){ where(times: times) }
  scope :first_times, -> {times 1}
  scope :second_times, -> {times 2}
  scope :base, -> {joins(:product, :credit_eval)}
  scope :period, ->(period){ base.where({products: {period_num: period[0..-2], period_unit: period[-1]}}) }
  scope :score_interval, ->(scores){ gteq, lt = scores.split(','); base.where({credit_evals: {score_gteq: gteq, score_lt: lt}}) }
  scope :by_product, ->(product_id) { where(product_id: product_id) }


  
  def times_title
    times == 1 ? '首贷' : '续贷'
  end

end
