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

class JekyllAuth
  class AuthSite < Sinatra::Base
    include JekyllAuth::Helpers
    configure :production do
      require "rack-ssl-enforcer"
      use Rack::SslEnforcer if JekyllAuth.ssl?
    end

    use Rack::Session::Cookie,       :http_only => true,
                                     :secret    => ENV["SESSION_SECRET"] || SecureRandom.hex


    def authenticate
      redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri,:scope => SCOPES,:access_type => "offline")
    end

    get '/google-auth' do
      authenticate
    end

    get '/oauth2callback' do
      unless session["user"]
        access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
        session[:access_token] = access_token.token
        @message = "Successfully authenticated with the server"
        @access_token = session[:access_token]
        session["user"] = access_token.get('https://www.googleapis.com/oauth2/v2/userinfo').parsed
	session["email"] = session["user"]["email"]
	session["isWhitelisted"] = isWhitelisted(session["email"])
      end
      if session["isWhitelisted"]
        url = session['google-auth-redirect'] || to("/")
        redirect url
      else
	redirect to("/401.html")
      end
    end

    get '*' do
      pass if whitelisted?
      unless session["user"]
        session['google-auth-redirect'] = request.path
        redirect to("/login.html")
      end
      pass
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

