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
      @result[key] = value ? value : self.class.generate(block)
    end
  end
end
