class Role < ApplicationRecord
  has_many :role_ships, dependent: :destroy
  has_many :users, through: :role_ships, source: :roleable, source_type: "User"

  validates_presence_of :code, :name
end
