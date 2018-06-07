class LoanFee < ApplicationRecord

  include Filterable

  belongs_to :credit_eval
  belongs_to :product
  belongs_to :user

  validates_presence_of :product_id, :credit_eval_id
  validates_with LoanFeeUniqValidator
  validates_with LoanFeeActiveConflictValidator

  delegate :name, to: :user, prefix: true

  scope :asc, ->(column){order(column)}
  scope :desc, ->(column){order("#{column.to_s} DESC")}

  scope :times, ->(times){ where(times: times) }
  scope :first_times, -> {times 1}
  scope :second_times, -> {times 2}
  scope :base, -> {joins(:product, :credit_eval)}
  scope :period, ->(period){ base.where({products: {period_num: period[0..-2], period_unit: period[-1]}}) }
  scope :score_interval, ->(scores){ gteq, lt = scores.split(','); base.where({credit_evals: {score_gteq: gteq, score_lt: lt}}) }


end
