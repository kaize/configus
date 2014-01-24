require 'bundler/setup'
Bundler.require

if ENV["TRAVIS"]
  require 'coveralls'
  Coveralls.wear!
end

def fixtures_path
  @path ||= File.expand_path(File.join(__FILE__, "../fixtures"))
end
