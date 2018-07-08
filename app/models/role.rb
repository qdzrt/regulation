class Role < ApplicationRecord
  has_many :role_ships, dependent: :destroy
  has_many :users, through: :role_ships, source: :roleable, source_type: "User"

  validates_presence_of :code, :name
  validates :code, format: { with: /\A[a-zA-Z]+\z/ }
  validates :name, format: { with: /\A[\u4e00-\u9fa5]+\z/ }
end
