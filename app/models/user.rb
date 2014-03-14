class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email = email.downcase }

  validates :email, presence: true, length: {maximum: 100}, 
            format: { with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false}
  validates :password, length: { minimum: 6 }

  has_secure_password
  
end
