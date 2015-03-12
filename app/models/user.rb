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

  has_many :sessions,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'Session'

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user.is_password?(password) ? user : nil
  end

  def add_session_token!(options = {})
    session_token = SecureRandom.urlsafe_base64
    Session.create(user_id: id, token: session_token,
                   environment: options[:environment], location: options[:location])
    session_token
  end

  def delete_session_token!(token)
    Session.where(user_id: id, token: token).destroy_all
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    save
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
