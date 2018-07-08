module Roleable
  extend ActiveSupport::Concern

  included do
    has_many :role_ships, as: :roleable, dependent: :destroy
    has_many :roles, through: :role_ships

    include InstanceMethods
  end

  module InstanceMethods
    def role_codes
      roles.pluck(:code)
    end

    def role_names
      roles.pluck(:name)
    end
  end
end