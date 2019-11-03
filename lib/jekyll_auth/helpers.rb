# frozen_string_literal: true
require 'json'

EMAIL_FILE = File.read('whitelisted_email.json')
WHITELISTED_EMAILS = JSON.parse(EMAIL_FILE)["emails"]
class JekyllAuth
  module Helpers

    def client
      client ||= OAuth2::Client.new(G_API_CLIENT, G_API_SECRET, {
        :site => 'https://accounts.google.com',
        :authorize_url => '/o/oauth2/auth',
        :token_url => '/o/oauth2/token'
      })
end
    def isWhitelisted(email)
	    return WHITELISTED_EMAILS.include? email 
    end
    def whitelisted?
      return true if request.path_info == "/logout"
      return true if request.path_info == "/login.html"
      return true if request.path_info == "/google-auth"
      !!(JekyllAuth.whitelist && JekyllAuth.whitelist.match(request.path_info))
    end
  end
end
