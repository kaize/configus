module Configus
  class Builder

    class << self
      def build(current_env, &block)
        b = new(current_env, block)
        Config.new(b.result)
      end
    end

    def initialize(current_env, block)
      @current_env = current_env.to_sym
      @envs = {}
      instance_eval &block
    end

    def result(env = nil)
      env_name = env || @current_env
      e = @envs[env_name]
      unless e
        raise "Call undefined env '#{env_name}'"
      end

      current_config = {}
      if e[:block]
        current_config = Proxy.generate(e[:block])
      end

      parent = e[:options][:parent]
      if parent
        parent_config = result(parent)
        current_config = deep_merge(parent_config, current_config)
      end

      current_config
    end

    private

      def env(env, options = {}, &block)
        env = env.to_sym
        raise ArgumentError, "Double definition of environment '#{env}'" if @envs.keys.include?(env)

        @envs[env] = {
          :options => options,
        }
        @envs[env][:block] = block if block_given?
      end

      def deep_merge(target, source)
        source.each_pair do |k,v|
          tv = target[k]
          target[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? deep_merge(tv, v) : v
        end
        target
      end

  end
end
