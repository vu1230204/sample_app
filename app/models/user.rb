class User < ApplicationRecord
  attr_accessor :remember_token

  # Before Method

  # Before_save
  before_save :downcase_email

  # Validate Name
  validates :name, presence: true,
             length: {minimum: Settings.user.name.min_length,
                      maximum: Settings.user.name.max_length}

  # Validate Email
  VALIDATES_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
            length: {maximum: Settings.user.email.max_length},
            format: {with: VALIDATES_EMAIL_REGEX}

  # Validate Password
  validates :password, presence: true,
            length: {minimum: Settings.user.password.min_length,
                     maximum: Settings.user.password.max_length},
            allow_nil: true
  has_secure_password

  # public method

  # create  token and save  database in column remember_digest
  def remember
    remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  # reset digest token
  def forget
    update remember_digest: nil
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Class Method

  class << self
    # return the hash digest of the given string
    def digest string
      cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
      cost = BCrypt::Engine.cost unless ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create(string, cost: cost)
    end

    # create new token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Private method

  private
  # save email user lowercase letter
  def downcase_email
    email.downcase!
  end
end
