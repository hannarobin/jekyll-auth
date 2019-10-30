# frozen_string_literal: true
require 'sinatra'
require 'oauth2'
require 'json'

enable :sessions

SCOPES = ['https://www.googleapis.com/auth/userinfo.email'].join(' ')

unless G_API_CLIENT = ENV['G_API_CLIENT']
  raise "You must specify the G_API_CLIENT env variable"
end

unless G_API_SECRET = ENV['G_API_SECRET']
  raise "You must specify the G_API_SECRET env variable"
end

def client
  client ||= OAuth2::Client.new(G_API_CLIENT, G_API_SECRET, {
    :site => 'https://accounts.google.com',
    :authorize_url => '/o/oauth2/auth',
    :token_url => '/o/oauth2/token'
  })
end


class JekyllAuth
  class AuthSite < Sinatra::Base
#    configure :production do
#      require "rack-ssl-enforcer"
#      use Rack::SslEnforcer if JekyllAuth.ssl?
#    end

#    use Rack::Session::Cookie,       :http_only => true,
#                                     :secret    => ENV["SESSION_SECRET"] || SecureRandom.hex


    use Rack::Logger

#    before do
      #pass if request.path_info.start_with?('/auth/google_oauth2')
#      pass if whitelisted?
#      authenticate
#    end
    get '/' do
      erb :index
#      authenticate
#      'hello'
    end

    get "/auth" do
     redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri,:scope => SCOPES,:access_type => "offline")
    end

    get '/oauth2callback' do
      access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
      session[:access_token] = access_token.token
      @message = "Successfully authenticated with the server"
      @access_token = session[:access_token]

      # parsed is a handy method on an OAuth2::Response object that will
      # intelligently try and parse the response.body
      @email = access_token.get('https://www.googleapis.com/userinfo/email?alt=json').parsed
      erb :success
    end

    def redirect_uri
      uri = URI.parse(request.url)
      uri.path = '/oauth2callback'
      uri.query = nil
      uri.to_s
    end

    get "/logout" do
      logout!
      redirect "/"
    end
  end
end
