class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true
  VALIDATES_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALIDATES_EMAIL_REGEX}
    def downcase_email
      email.downcase!
    end
  has_secure_password
end
