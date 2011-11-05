require 'singleton'

module Configus
  class Config
    def initialize(config, section = nil)
      @config = {}
      config.each_pair do |key, value|
        @config[key] = value.is_a?(Hash) ? Config.new(value) : value
      end

      (class << self; self; end).class_eval do
        config.each_pair do |key, value|
          if value.is_a? Hash
            value = Config.new(value)
          end

          define_method key.to_sym do
            value
          end
        end
      end
    end

    def [](key)
      @config[key]
    end

    def method_missing(meth, *args, &blk)
      raise "'#{meth}' key does not exists in your configus"
    end
  end
end
