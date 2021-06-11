# frozen_string_literal: true

require 'http'

module Rewards
  # Returns an authenticated user, or nil
  class AuthenticateAccount
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(email:, password:)
      response = HTTP.post(
        "#{@config.API_URL}/auth/authenticate",
        json: { email: email, password: password }
      )

      raise(UnauthorizedError) unless response.code == 200

      response.parse['attributes']
    end
  end
end
