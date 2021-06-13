# frozen_string_literal: true

require 'rake/testtask'
require './require_app'

task :print_env do
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
end

desc 'Run application console (pry)'
task console: :print_env do
  sh 'pry -r ./spec/test_load_all'
end

desc 'Rake all the Ruby'
task :style do
  `rubocop .`
end

namespace :run do
  # Run in development mode
  task :dev do
    sh 'rackup -p 9292'
  end
end

task :lib do
  require_app('lib')
end

namespace :generate do
  desc 'Create rbnacl key'
  task :msg_key => :lib do
    puts "MSG_KEY: #{SecureMessage.generate_key}"
  end

  desc 'Create cookie secret'
  task :session_secret => :lib do
    puts "SESSION_SECRET: #{SecureSession.generate_secret}"
  end
end

namespace :session do
  desc 'Delete all sessions in Redis'
  task :wipe => :lib do
    require 'redis'
    wiped = SecureSession.wipe_redis_sessions
    puts "#{wiped.count} sessions deleted"
  end
end
