class User < ApplicationRecord

  has_many_attached :images

  validates_presence_of :password, :password_confirmation, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: /\A([-a-z0-9+._]){1,64}@([-a-z0-9]+[.])+[a-z]{2,}\z/ }

  has_secure_password

  # scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }

  class << self
    def authorize!(credentials)
      find_by(email: credentials[:email]).try(:authenticate, credentials[:password])
    end
  end

end

