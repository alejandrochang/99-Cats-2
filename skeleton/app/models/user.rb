# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 8, allow_nil: true }
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  after_initialize :ensure_session_token

  attr_reader :password

  # associations

  has_many :cats
  has_many :catrentalrequest
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    user && user.is_password?(password) ? user : nil
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
