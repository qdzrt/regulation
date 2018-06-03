class Product < ApplicationRecord
  enum period_unit: {D: 0, M: 1, Y: 2}
  validates_presence_of :period_num, :period_unit, :name

  belongs_to :user
  has_many :loan_fees

  before_save :toggle_loan_fee

  delegate :name, to: :user, prefix: true

  def toggle_loan_fee
    self.loan_fees.update_all(active: active) if active == false
  end
end
