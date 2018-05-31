class User < ApplicationRecord
  has_secure_password

  class << self
    def authorize!(credentials)
      find_by(name: credentials[:name]).try(:authenticate, credentials[:password])
    end
  end

end

