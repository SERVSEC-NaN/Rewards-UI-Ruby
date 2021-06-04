# frozen_string_literal: true

require 'roda'
require_relative './app'

module Rewards
  # Web controller for Rewards API
  class App < Roda
    route('auth') do |routing|
      @login_route = '/auth/admin/login'
      routing.is 'admin/login' do
        # GET /auth/login
        routing.get do
          view :home
        end

        # POST /auth/admin/login
        routing.post do
          account = AuthenticateAccount.new(App.config).call(
            username: routing.params['username'],
            password: routing.params['password']
          )
          SecureSession.new(session).set(:current_account, account)
          flash[:notice] = "Welcome back #{account['username']}!"
          routing.redirect '/'
        rescue AuthenticateAccount::UnauthorizedError
          flash[:error] = 'Username and password did not match our records'
          response.status = 403
          routing.redirect @login_route
        end
      end

      # /auth/logout
      @logout_route = '/auth/admin/logout'
      routing.on 'admin/logout' do
        routing.get do
          SecureSession.new(session).delete(:current_account)
          flash[:notice] = 'Logged out successfully'
          routing.redirect @login_route
        end
      end
    end
  end
end
