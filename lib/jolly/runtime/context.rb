module Jolly
  module Runtime
    class Context
      include Jolly::DSL

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

        parent_module.const_set(api_module, @module = Module.new)
        @config = {}
      end

      # Called to compile the definition into a new Jolly API module.
      def __compile__(&definition)
        # This executes the definition of the API within this context.
        # The methods called inside the definition block are defined in Jolly::DSL::API
        # It will build a reference target for the Jolly API in @config
        instance_eval(&definition)

        # Close the last method description in the definition
        __close_description

        puts '== Configuration complete =='
        puts @config

        # The proxy contains all helper methods for the new Jolly API.
        # This includes things like 'validate_<method>', 'authorize_<method>', etc.
        # It allows access to these helper methods from other Jolly APIs,
        # so we can chain validations and calls across Jolly APIs.
        @module.class_variable_set(:@@__jolly__, proxy = Jolly::Runtime::Proxy.new)
        @module.module_eval do
          def self.__jolly__
            class_variable_get(:@@__jolly__)
          end
        end

        # Compile @config into module methods and proxy methods
        puts proxy
      end
    end
  end
end
