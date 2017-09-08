module Configus
  class Proxy
    attr_reader :result

    class << self
      def generate(block)
        p = new(block)
        p.result
      end
    end

    def initialize(block)
      @result = {}
      instance_eval &block
    end

    def method_missing(key, value = nil, &block)
      raise ArgumentError, "Double definition of key '#{key}'" if @result.has_key?(key)

      @result[key] = block_given? ? self.class.generate(block) : value
    end
  end
end
