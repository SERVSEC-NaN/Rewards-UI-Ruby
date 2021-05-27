# frozen_string_literal: true

require 'redis'
require_relative 'secure_message'

class SecureSession
  def self.setup(redis_url)
    @redis_url = redis_url
  end

  def self.generate_secret
    SecureMessage.encoded_random_bytes(64)
  end

  def self.wipe_redis_sessions
    redis = Redis.new(url: @redis_url)
    redis.key.each { |session_id| redis.del session_id }
  end

  def initialize(session)
    @session = session
  end

  def set(key, value)
    @session[key] = SecureMessage.encrypt(value)
  end

  def get(key)
    return nil unless @session[key]

    SecureMessage.decrypt(@session[key])
  end

  def delete(key)
    @session.delete(key)
  end
end
