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
          case value
          when Hash
            value = Config.new(value)
          when Proc
            value
          end

          define_method key.to_sym do
            value.is_a?(Proc) ? instance_exec(&value) : value
          end
        end
      end
    end

    def [](key)
      @config[key]
    end

    def to_hash
      hash = {}
      @config.each_pair do |key, value|
        hash[key] = value.respond_to?(:to_hash) ? value.to_hash : value
      end
      hash
    end

    def each_pair(&block)
      #TODO: hash values should be Configus instance object
      @config.each_pair(&block)
    end

    def method_missing(meth, *args, &blk)
      raise "'#{meth}' key does not exist in your configus"
    end
  end
end
