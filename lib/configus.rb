require 'active_support/core_ext/hash'

require "configus/version"
require 'configus/builder'
require 'configus/proxy'
require 'configus/config'
require 'configus/core_ext/kernel'

module Configus
  def self.build(env, &block)
    @config = Builder.build(env, &block)
  end

  def self.config
    @config
  end
end
