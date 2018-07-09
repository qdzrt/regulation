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

    def method_missing(method_name)
      if method_name.to_s.end_with?('?')
        role_codes.include?(method_name[0..-2])
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.end_with?('?') || super
    end
  end
end