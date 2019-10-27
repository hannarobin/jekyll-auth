# frozen_string_literal: true

require "./lib/jekyll_auth/version"

Gem::Specification.new do |s|
  s.name                  = "jekyll-auth"
  s.version               = JekyllAuth::VERSION
  s.summary               = "A simple way to use Google OAuth2 to serve a protected jekyll site"
  s.description           = "A simple way to use Google OAuth2 to serve a protected jekyll site"
  s.authors               = "Robin Altena"
  s.email                 = "altenarobin@gmail.com"
  s.homepage              = "https://github.com/murrx/jekyll-auth"
  s.license               = "MIT"
  s.files                 = `git ls-files`.split("\n")
  s.test_files            = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables           = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths         = ["lib"]

  s.add_dependency "activesupport", "~> 4.0"
  s.add_dependency "colorator", "~> 1.0"
  s.add_dependency "dotenv", "~> 2.0"
  s.add_dependency "jekyll", "~> 3.0"
  s.add_dependency "mercenary", "~> 0.3"
  s.add_dependency "rack", "~> 1.6"
  s.add_dependency "rack-protection", "~> 1.5", ">= 1.5.5"
  s.add_dependency "rack-ssl-enforcer", "~> 0.2"
  s.add_dependency "rake", "~> 10.3"
  s.add_dependency "safe_yaml", "~> 1.0"
  s.add_dependency "sinatra-index", "~> 0.0"
  s.add_dependency "mail", "~>2.6"
  s.add_development_dependency "pry", "~> 0.10"
  s.add_development_dependency "rack-test", "~> 0.6"
  s.add_development_dependency "rspec", "~> 3.1"
  s.add_development_dependency "rubocop", "~> 0.49", ">= 0.49.0"
  s.add_development_dependency "webmock", "~> 1.2 "
end
