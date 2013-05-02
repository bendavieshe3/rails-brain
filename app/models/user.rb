require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :email_address, :is_admin, :name, :password_hash

  validates :email_address, :password_hash, presence:true

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
