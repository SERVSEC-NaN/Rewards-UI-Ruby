# frozen_string_literal: true

require 'base64'
require_relative 'secure_message'

class RegisterToken
  ONE_HOUR = 60 * 60
  ONE_DAY = ONE_HOUR * 24
  ONE_WEEK = ONE_DAY * 7
  ONE_MONTH = ONE_WEEK * 4
  ONE_YEAR = ONE_MONTH * 12

  class ExpiredTokenError < StandardError; end

  class InvalidTokenError < StandardError; end

  def self.create(payload, expiration = ONE_HOUR)
    contents = { 'payload' => payload, 'exp' => expires(expiration) }
    tokenize(contents)
  end

  def self.payload(token)
    contents = detokenize(token)
    expired?(contents) ? raise(ExpiredTokenError) : contents['payload']
  end

  def self.tokenize(message)
    return nil unless message

    SecureMessage.encrypt(message)
  end

  def self.detokenize(ciphertext64)
    return nil unless ciphertext64

    SecureMessage.decrypt(ciphertext64)
  rescue StandardError
    raise InvalidTokenError
  end

  def self.expires(expiration)
    (Time.now + expiration).to_i
  end

  def self.expired?(contents)
    Time.now > Time.at(contents['exp'])
  rescue StandardError
    raise InvalidTokenError
  end
end
