require 'singleton'
require 'yaml'

module Configus
  class Config
    def initialize(config, predefined_configs = [])
      @config = {}

      if predefined_configs.any?
        predefined_configs.each do |pconf_file|
          if File.exist?(pconf_file)
            pconf = YAML.load_file(pconf_file)
            pconf = symbolize_keys(pconf)
            config = pconf.merge(config)
          else
            puts "WARNING: You try to load config from file '#{pconf_file}', which are unavailable. Skipped."
          end
        end
      end

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

    private

    def symbolize_keys(hash)
      hash.inject({}){|result, (key, value)|
        new_key = case key
                  when String then key.to_sym
                  else key
                  end
        new_value = case value
                    when Hash then symbolize_keys(value)
                    else value
                    end
        result[new_key] = new_value
        result
      }
    end
  end
end
