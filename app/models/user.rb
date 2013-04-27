class User < ActiveRecord::Base
  attr_accessible :email_address, :is_admin, :name, :password_hash
end
