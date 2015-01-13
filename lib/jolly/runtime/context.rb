module Jolly
  module Runtime
    class Context
      include Jolly::DSL::API

      def initialize(module_name)
        module_chain = module_name.split('::')
        api_module = module_chain.pop

        parent_module = module_chain.inject(Object) do |parent, constant|
          begin
            parent.const_get(constant)
          rescue NameError
            parent.const_set(constant, Module.new)
          end
        end

        parent_module.const_set(api_module, @__module__ = Module.new)
      end

      # Called to compile the definition into a new Jolly API module.
      def __compile__(&definition)
        # This executes the definition of the API within this context.
        # The methods called inside the definition block are defined in Jolly::DSL::API
        # It should build a reference target for the Jolly API in @__internal__
        instance_eval(&definition)

        # The proxy contains all helper methods used by all the methods defined in the new Jolly API.
        # This includes things like 'validate_<method>', 'authorize_<method>', etc.
        # It allows access to these helper methods from other Jolly APIs, so we can chain validations and such.
        @__module__.class_variable_set(:@@__jolly__, proxy = Jolly::Runtime::Proxy.new)
        @__module__.module_eval do
          def self.__jolly__
            return class_variable_get(:@@__jolly__)
          end
        end
      end
    end
  end
end
