# terms of service https://karolgalanciak.com/blog/2018/06/24/rails-and-conditional-validations-in-models/

class User < ApplicationRecord

  include Filterable
  include Roleable

  STATUS = {
    true: '激活',
    false: '未激活'
  }

  has_many_attached :images
  has_many_attached :documents

  validates :name, presence: true
  validates_presence_of :password, :password_confirmation, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: /\A([-a-z0-9+._]){1,64}@([-a-z0-9]+[.])+[a-z]{2,}\z/ }

  attr_accessor :terms_of_service, :remember_me
  validates_acceptance_of :terms_of_service, on: :create

  has_secure_password
  # scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }
  scope :search, ->(name) { where(arel_table[:name].matches("%#{name}%")) }

  class << self
    def authorize!(credentials)
      find_by(email: credentials[:email]).try(:authenticate, credentials[:password])
    end
  end

end

