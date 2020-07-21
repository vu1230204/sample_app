class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{self.email = email.downcase}

  validates :name, presence: true
  VALIDATES_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, format: {with: VALIDATES_EMAIL_REGEX}
  # def downcase_email
  #   email.downcase!
  # end
  has_secure_password
  # Returns the hash digest of the given string.
  def self.digest string
    cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
    cost = BCrypt::Engine.cost unless ActiveModel::SecurePassword.min_cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
