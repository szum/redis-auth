require 'bcrypt'

class CreateUser
  include ActiveModel::Validations

  attr_reader :email, :name, :password, :password_confirmation
  attr_accessor :success, :error_messages

  def self.call(*args)
    new(*args).call
  end

  def initialize(user_params)
    # @email = session_params.fetch(:email)
    # @password = session_params.fetch(:password)
    @name = user_params.fetch(:name).downcase
    @email = user_params.fetch(:email).downcase
    @password = BCrypt::Password.create(user_params.fetch(:password))
    @password_confirmation = BCrypt::Password.create(user_params.fetch(:password_confirmation))
    self.error_messages = []
  end

  def call
    # if authentication_successful?
    #   user.update(failed_attempts: 0)
    #   @success = true
    # else
    #   @success = false
    #   handle_authentication_failure
    # end
    validate_username_uniqueness!
    validate_email_uniqueness!
    validate_password_presence!
    validate_confirmation_of_password!

    if valid?
      @id = generate_id!
      whitelist_username!
      whitelist_email!

      redis_create = REDIS.mapped_hmset("user:#{@name}", {
        "id" => @id,
        "name" => @name,
        "email" => @email,
        "password" => @password,
        "password_confirmation" => @password_confirmation
      })

      self.success = redis_create == "OK"
    else
      self.success = false
    end
    return result
  end

  private
  def whitelist_username!
    REDIS.hset('users:', @name, @id)
  end

  def whitelist_email!
    REDIS.hset('emails:', @email, @id)
  end

  def generate_id!
    REDIS.incr('user:id:')
  end

  def valid?
    true
    # self.error_messages.empty?
  end

  def validate_username_uniqueness!
    if REDIS.hget('users:', @name)
      self.error_messages << "Username is taken. Type in a username that's unique"
    end
    true
  end

  def validate_email_uniqueness!
    if REDIS.hget('emails:', @name)
      self.error_messages << "A user has already registered with that email."
    end
    true
  end

  def validate_password_presence!
    if @password.blank?
      self.error_messages << "Your password is blank."
    end
    true
  end

  def validate_confirmation_of_password!
    if @password_confirmation != @password
      self.error_messages << "Your password confirmation does not match your password."
    end
    true
  end

  def result
    OpenStruct.new(success?: self.success, error_messages: self.error_messages, user_id: @id)
  end

  # def authentication_successful?
  #   return false unless user
  #   user.login_allowed? && user.authenticate(password)
  # end

  # def handle_authentication_failure
  #   return unless user
  #   user.increment!(:failed_attempts)
  #   @error_message = 'You are locked' unless user.login_allowed?
  # end
end
