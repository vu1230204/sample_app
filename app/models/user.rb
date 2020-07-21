class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true
  VALIDATES_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, format: {with: VALIDATES_EMAIL_REGEX}
  def downcase_email
    email.downcase!
  end
  has_secure_password
  # Returns the hash digest of the given string.

  def self.digest string
    cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
    cost = BCrypt::Engine.cost unless ActiveModel::SecurePassword.min_cost
    BCrypt::Password.create(string, cost: cost)
  end
end
