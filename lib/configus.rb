require "configus/version"
require 'configus/core_ext/kernel'

module Configus
  autoload :Builder, 'configus/builder'
  autoload :Proxy, 'configus/proxy'
  autoload :Config, 'configus/config'

  def self.build(env, &block)
    @config = Builder.build(env, &block)
  end

  def self.config
    @config
  end
end
