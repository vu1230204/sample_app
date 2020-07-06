class User < ApplicationRecord
  before_save	:downcase_email
	validates :name, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.feeze
	validates :email, presence: true, length: {maximum: Settings.user.email.max_length},
	format: {with: VALID_EMAIL_REGEX}

	has_secure_password

	private

	def downcase_email
		email.downcase!
	end
end
