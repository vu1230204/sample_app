class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :create_activation_digest

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
  def authenticated? attribute, remember_token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(remember_token)
  end

  # Activates an account.
  def activate
    update(activated: true)
    update(activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Create token and save databse attribute reset_digest
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_send_at: Time.zone.now)
  end

  # use UserMailer chapter11 send email now
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # check time after sendMail
  def password_reset_expired?
    reset_send_at > 2.hours.ago
  end
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

  private

  # Save email user lowercase letter
  def downcase_email
    email.downcase!
  end

  # Create token activated email
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
