# frozen_string_literal: true

require_relative '../require_app'
require_app

# run pry -r <path/to/this/file>
require 'rack/test'
include Rack::Test::Methods # rubocop:disable Style/MixinUsage

def app
  Rewards::App
end

unless app.environment == :production
  require 'rack/test'
  include Rack::Test::Methods # rubocop:disable Style/MixinUsage
end
