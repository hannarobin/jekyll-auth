# frozen_string_literal: true

class JekyllAuth
  module Helpers
    def whitelisted?
      return true if request.path_info == "/logout"
      !!(JekyllAuth.whitelist && JekyllAuth.whitelist.match(request.path_info))
    end
  end
end
