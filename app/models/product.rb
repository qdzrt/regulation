# frozen_string_literal: true

class Product < ApplicationRecord

  ZERO = 0
  ONE = 1
  TWO = 2

  enum period_unit: {D: ZERO, M: ONE, Y: TWO}
  validates_presence_of :period_num, :period_unit, :name

  belongs_to :user
  has_many :loan_fees

  before_save :toggle_loan_fee

  delegate :name, to: :user, prefix: true

  def toggle_loan_fee
    self.loan_fees.update_all(active: active) if active == false
  end
end
