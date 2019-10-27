# frozen_string_literal: true
require 'sinatra'
require 'sinatra/google-auth'
require 'mail'

class JekyllAuth
  class AuthSite < Sinatra::Base
#    configure :production do
#      require "rack-ssl-enforcer"
#      use Rack::SslEnforcer if JekyllAuth.ssl?
#    end

#    use Rack::Session::Cookie,       :http_only => true,
#                                     :secret    => ENV["SESSION_SECRET"] || SecureRandom.hex

    register Sinatra::GoogleAuth

    use Rack::Logger

#    before do
      #pass if request.path_info.start_with?('/auth/google_oauth2')
#      pass if whitelisted?
#      authenticate
#    end
    get '*' do
      authenticate
      'hello'
    end

    get "/logout" do
      logout!
      redirect "/"
    end
  end
end
