require 'bcrypt'

class CreateUser
  attr_reader :name, :password, :password_confirmation
  attr_accessor :success, :error_messages

  def self.call(*args)
    new(*args).call
  end

  def initialize(user_params)
    @id = nil
    @name = user_params.fetch(:name).downcase
    @password = user_params.fetch(:password)
    @password_confirmation = user_params.fetch(:password_confirmation)
    self.error_messages = []
  end

  def call
    validate_username_uniqueness!
    validate_password_presence!
    validate_password_complexity!
    validate_confirmation_of_password!

    if valid?
      bcrypt_password!
      @id = generate_id!
      whitelist_username!

      redis_create = REDIS.mapped_hmset("user:#{@id}", {
        "id" => @id,
        "name" => @name,
        "password" => @password,
      })

      self.success = redis_create == "OK"
    else
      self.success = false
    end
    return result
  end

  private

  def bcrypt_password!
    @password = BCrypt::Password.create(@password)
    @password_confirmation = nil
  end

  def validate_password_complexity!
    rules = {
      "Password must contain at least one lowercase letter."  => /[a-z]+/,
      "Password must contain at least one uppercase letter."  => /[A-Z]+/,
      "Password must contain at least one digit."             => /\d+/,
      "Password must contain at least one special character." => /[^A-Za-z0-9]+/
    }

    rules.each do |message, regex|
      self.error_messages << message unless @password.match(regex)
    end
  end

  def whitelist_username!
    REDIS.hset('users:', @name, @id)
  end

  def generate_id!
    REDIS.incr('user:id:')
  end

  def valid?
    self.error_messages.empty?
  end

  def validate_username_uniqueness!
    if REDIS.hget('users:', @name)
      self.error_messages << "Username is taken. Type in a username that's unique."
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
    OpenStruct.new(success?: self.success, error_messages: self.error_messages, user_id: @id, user_name: @name)
  end
end
