class LoanFee < ApplicationRecord
  belongs_to :credit_eval
  belongs_to :product
  belongs_to :user

  delegate :name, to: :user, prefix: true
end
