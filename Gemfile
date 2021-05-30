# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web
gem 'puma'
gem 'roda'
gem 'slim'

# Configuration
gem 'figaro'
gem 'rake'

# Debugging
gem 'pry'

# Cookies
gem 'redis'
gem 'redis-rack'

# Communication
gem 'http'

# Security
gem 'rack-ssl-enforcer'
gem 'rbnacl' # assumes libsodium package already installed

group :development, :test do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rack-test'
  gem 'rerun'
end
