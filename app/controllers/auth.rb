# frozen_string_literal: true

require 'roda'
require_relative './app'

module Rewards
  # Web controller for Rewards API
  class App < Roda
    route('auth') do |routing|
      @login_route = '/auth/login'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :home
        end

        # POST /auth/admin/login
        routing.post do
          account = AuthenticateAccount.new(App.config).call(
            email: routing.params['email'],
            password: routing.params['password']
          )
          current_account = CurrentAccount.new(
            account[:account],
            account[:auth_token]
          )

          CurrentSession.new(session).current_account = current_account
          flash[:notice] = "Welcome back #{account['email']}!"
          routing.redirect '/'
        rescue AuthenticateAccount::UnauthorizedError
          flash[:error] = 'Email and password did not match our records'
          response.status = 403
          routing.redirect @login_route
        end
      end

      # /auth/logout
      @logout_route = '/auth/logout'
      routing.on 'logout' do
        routing.get do
          CurrentSession.new(session).delete
          flash[:notice] = 'Logged out successfully'
          routing.redirect @login_route
        end
      end

      @register_route = '/auth/register'
      routing.on 'register' do
        routing.is do
          # GET /auth/register
          routing.get do
            view :register
          end

          # POST /auth/register
          routing.post do
            account_data = JsonRequestBody.symbolize(routing.params)
            VerifyRegistration.new(App.config).call(account_data)

            flash[:notice] = 'Please check your email for a verification link'
            routing.redirect '/'
          rescue StandardError => e
            puts "ERROR VERIFYING REGISTRATION: #{e.inspect}"
            flash[:error] = 'Registration details are not valid'
            routing.redirect @register_route
          end
        end

        # GET /auth/register/<token>
        routing.get(String) do |registration_token|
          # verify register token expire or not
          new_account = RegisterToken.payload(registration_token)
          flash.now[:notice] = 'Email Verified! Please choose a new password'
          view :register_confirm, locals: { new_account: new_account, registration_token: registration_token }
        rescue RegisterToken::ExpiredTokenError
          flash[:error] = 'The register token has expired, please register again.'
          response.status = 403
          routing.redirect @register_route
        end
      end
    end
  end
end
