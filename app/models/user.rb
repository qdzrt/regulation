class User < ApplicationRecord
  validates_presence_of :password, :password_confirmation, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: /\A([-a-z0-9+._]){1,64}@([-a-z0-9]+[.])+[a-z]{2,}\z/ }

  has_secure_password

  class << self
    def authorize!(credentials)
      find_by(email: credentials[:email]).try(:authenticate, credentials[:password])
    end
  end

end

