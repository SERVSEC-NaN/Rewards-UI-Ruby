# frozen_string_literal: true

require 'http'

# Create an account using email and usertype
module Rewards
  class CreateAccount
    class InvalidAccount < StandardError; end

    def initialize(config)
      @config = config
    end
    
    def call(type:, email:, password:)
      message = {
        type: type,
        email: email,
        password: password
      }
      
      if type == "subscriber"
        response = HTTP.post(
          "#{@config.API_URL}/subscriber/",
          json: message
        )
        p "A subscriber is created!"
      elsif type == "promoter"
        response = HTTP.post(
          "#{@config.API_URL}/promoter/",
          json: message
        )
        p "A promoter is created!"
      end
      raise InvalidAccount unless response.code == 201
    end
  end
end