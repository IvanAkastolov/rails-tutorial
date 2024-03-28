class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[a-z0-9+.\-_]+@[a-z\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, length: {minimum: 6}

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
