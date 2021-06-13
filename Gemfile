# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web
gem 'puma', '~> 5.3.1'
gem 'roda'
gem 'slim'

# Debugging
gem 'pry'
gem 'rack-test'

# Configuration
gem 'figaro'
gem 'rake'

# Communication
gem 'http'
gem 'redis'
gem 'redis-rack'

# Security
gem 'rack-ssl-enforcer'
gem 'rbnacl' # assumes libsodium package already installed

group :development, :test do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rerun'
end
