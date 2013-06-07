require 'bundler/setup'
Bundler.require

if ENV["TRAVIS"]
  require 'coveralls'
  Coveralls.wear!
end
