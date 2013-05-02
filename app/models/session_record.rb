class SessionRecord < ActiveRecord::Base
  attr_accessible :key, :user_id

  validates :key, :user_id, presence:true

  before_validation :generate_key

  def generate_key
    self.key = SecureRandom.uuid unless self.key
  end

end
