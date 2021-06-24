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
      response = HTTP.post("#{@config.API_URL}/accounts/", json: message)
      raise InvalidAccount unless response.code == 201
    end
  end
end
