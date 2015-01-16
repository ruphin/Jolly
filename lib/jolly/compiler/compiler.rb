module Jolly
  module Compiler

    # Called to compile the configuration into a Module.
    def compile(mdl, configuration)

      # The Jolly Runtime contains all helper methods for the new API.
      # This includes things like 'validate_<method>', 'authorize_<method>', etc.
      # It allows access to these helper methods from other Jolly Runtimes,
      # so we can chain validations and calls across APIs.
      mdl.class_variable_set(:@@__jolly__, jolly = Jolly::Runtime::Jolly.new)
      mdl.module_eval do
        def self.__jolly__
          class_variable_get(:@@__jolly__)
        end
      end

      Perform.compile(jolly, configuration)

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
