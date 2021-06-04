# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'rack/ssl-enforcer'
require 'rack/session/redis'

require_relative '../require_app'
require_app('lib')

module Rewards
  # Configuration for the API
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment: environment,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config() = Figaro.env

    # Logger setup
    LOGGER = Logger.new($stderr)
    def self.logger() = LOGGER

    ONE_MONTH = 30 * 24 * 60 * 60

    configure do
      SecureSession.setup(ENV['REDIS_TSL_URL']) # REDIS_URL used again below
      SecureMessage.setup(ENV.delete('MSG_KEY'))
    end

    configure :production do
      use Rack::SslEnforcer, hsts: true
      use Rack::Session::Redis,
          expire_after: ONE_MONTH,
          redis_server: {
            url: ENV.delete('REDIS_URL'),
            ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
          }
    end

    configure :development, :test do
      require 'pry'

      use Rack::Session::Pool, expire_after: ONE_MONTH

      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./spec/test_load_all'
      end
    end
  end
end
