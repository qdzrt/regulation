class Product < ApplicationRecord
  enum period_unit: {D: 0, M: 1, Y: 2}
  validates_presence_of :period_num, :period_unit, :name

  belongs_to :user

end
