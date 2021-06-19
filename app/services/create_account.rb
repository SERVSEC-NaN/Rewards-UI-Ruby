# frozen_string_literal: true

require 'http'

module Rewards
  # Create an account using email and usertype
  class CreateAccount
    class InvalidAccount < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(type:, email:, password:)
      message = { type: type, email: email, password: password }
      p type
      case type
      when 'subscriber'
        response = HTTP.post("#{@config.API_URL}/subscribers/", json: message)
        p message
        p 'A subscriber is created!'
      when 'promoter'
        response = HTTP.post("#{@config.API_URL}/promoters/", json: message)
        p 'A promoter is created!'
      else
        raise InvalidAccount
      end
      raise InvalidAccount unless response.code == 201
    end
  end
end
