# frozen_string_literal: true

class CreditEval < ApplicationRecord

  MAX_SCORE = 1000

  belongs_to :user
  has_many :loan_fees

  validates_presence_of :score_gteq, :score_lt, :grade
  validates_numericality_of :score_gteq, only_integer: true, greater_than_or_equal_to: 0
  validates_numericality_of :score_lt, only_integer: true, greater_than: :score_gteq, less_than_or_equal_to: MAX_SCORE

  validates_with ScoreIntervalValidator

  delegate :name, to: :user, prefix: true

  def score_interval
    ['[', score_gteq, ',', score_lt, ')'].join if score_gteq && score_lt
  end
end
