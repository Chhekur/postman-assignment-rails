class User < ApplicationRecord
	has_secure_password
	has_one :calendar, dependent: :destroy
	validates :email, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 50}, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
  validates :password, presence: true, length: {minimum: 6, maximum: 20}
  validates :name, presence: true, length: {maximum: 20}
end
