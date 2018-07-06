class RoleShip < ApplicationRecord
  belongs_to :roleable, polymorphic: true
  belongs_to :role
end
