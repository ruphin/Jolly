module Jolly
  module Runtime
    class Context
      include Jolly::Parser::DSL

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
        proxy.instance_variable_set("@config", @config)

        ##################
        # DEFINE PERFORM #
        ##################
        proxy.__eigenclass.send(:define_method, "perform") do |method, s|
          s.__eigenclass.send(:define_method, "__perform", @config[:methods][method][:perform])
          return s.__perform
        end

        ##################
        # SET PARAMETERS #
        ##################
        proxy.__eigenclass.send(:define_method, "define_params") do |method, s, params|
          params.each do |name, value|
            if @config[:methods][method][:parameters].keys.include? name
              #Jolly::Runtime::Coercers.coerce(param, @config[:methods][method][:parameters][param][:type])
              if @config[:methods][method][:parameters][:multiple]
              end
              s.instance_variable_set("@#{name}", value)
              s.__eigenclass.send(:define_method, name) do
                return instance_variable_get("@#{name}")
              end
            else
              raise Jolly::Exceptions::Runtime::Parameter, "Parameter #{name} is not allowed on derp"
            end
          end
        end

        ###############################
        # DEFINE MODULE API ACCESSORS #
        ###############################
        eigenclass = class << @module; self; end
        @config[:methods].keys.each do |method|
        eigenclass.send(:define_method, method) do |params|
          scope = Jolly::Runtime::Scope.new
            __jolly__.define_params(method, scope, params)
            __jolly__.perform(method, scope)
          end
        end

        # # TODO: The perform methods need to be wrapped so they are instance_evalled on scope?
        # # Define the perform_methods on the proxy
        # @config.each do |method, definition|
        #   proxy.__eigenclass.send(:define_method, "perform_#{method}", &definition[:perform])
        # end

        # # Compile @config into module methods and proxy methods
        # proxy.__eigenclass.class_eval do
        #   def parse_params_derp(scope, params)
        #     params.map do |param|
        #       # This should not map, it should define the parameters on the scope immediately.
        #       if @config[:derp][:parameters].keys.include? param
        #         next Jolly::Runtime::Coercers.coerce(param, @config[:derp][:parameters][param][:type])
        #       else
        #         raise Jolly::Exception::ParameterException, "Parameter #{param} is not allowed on derp"
        #       end
        #     end
        #   end
        # end
      end
    end
  end
end
