class User
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :id, :name
  attr_reader :password, :password_confirmation

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # has_secure_password
  # validates_presence_of :name
  # validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  # validates :password, presence: true, length: { minimum: 6 }

end
