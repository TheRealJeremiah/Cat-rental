require 'bcrypt'

class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, :session_token, uniqueness: true

  has_many :cats,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'Cat'

  has_many :cat_rental_requests,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'CatRentalRequest'

  after_initialize do
    reset_session_token!
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    save
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    save
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
