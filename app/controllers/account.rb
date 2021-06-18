# frozen_string_literal: true

require 'roda'
require_relative './app'

module Rewards
  # Web controller for Rewards API
  class App < Roda
    route('account') do |routing|
      routing.on do
        # GET /account/login
        routing.get String do |email|
          if @current_account && @current_account['email'] == email
            view :account, locals: { current_account: @current_account }
          else
            routing.redirect '/auth/login'
          end
        end

        routing.post String do |registration_token|
          raise 'Passwords do not match or empty' if
            routing.params['password'].empty? ||
            routing.params['password'] != routing.params['password_confirm']

          new_account = RegisterToken.payload(registration_token)
          CreateAccount.new(App.config).call(
            email: new_account['email'],
            type: new_account['type'],
            password: routing.params['password']
          )
          flash[:notice] = 'Account created! Please login'
          routing.redirect '/auth/login'
        rescue CreateAccount::InvalidAccount => e
          flash[:error] = e.message
          routing.redirect '/auth/register'
        rescue StandardError => e
          flash[:error] = e.message
          routing.redirect(
            "#{App.config.APP_URL}/auth/register/#{registration_token}"
          )
        end
      end
    end
  end
end
