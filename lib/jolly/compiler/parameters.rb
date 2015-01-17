module Jolly
  module Compiler
    module Parameters
      def self.compile(jolly, configuration)
        # Define a bunch of variables that contain method properties
        configuration[:methods].each do |method, method_definition|
          # The list of all parameters
          jolly.instance_variable_set("@parameters_#{method}", method_definition[:parameters].keys)

          # A type for each parameter
          method_definition[:parameters].each do |parameter, definition|
            jolly.instance_variable_set("@parameter_types_#{method}_#{parameter}", definition[:type])
          end

          # A list of all parameter conditions
          jolly.instance_variable_set("@parameter_conditions_#{method}", method_definition[:conditions])

          # The perform definitions
          jolly.instance_variable_set("@perform_#{method}", method_definition[:perform])

          # The return types. Default to Object.
          jolly.instance_variable_set("@return_type_#{method}", method_definition[:return] || Object)
        end

        jolly.__eigenclass.send(:define_method, 'define_parameters') do |method, scope, params|
          params.each do |name, value|
            if configuration[:methods][method][:parameters].keys.include? name
              # Jolly::Runtime::Coercers.coerce(param, @config[:methods][method][:parameters][param][:type])
              if configuration[:methods][method][:parameters][:multiple]
              end
              scope.instance_variable_set("@#{name}", value)
              scope.__eigenclass.send(:define_method, name) do
                return instance_variable_get("@#{name}")
              end
            else
              raise Jolly::Exceptions::Runtime::Parameter, "Parameter #{name} is not allowed on derp"
            end
          end
        end

        # Define the return types as instance variables
        configuration[:methods].each do |method, definition|
          if definition[:return]
            jolly.instance_variable_set("@return_type_#{method}", definition[:return])
          end
        end

        # Define a method that raises an exception if the return type is not correct
        jolly.__eigenclass.send(:define_method, :__check_return_type) do |method, value|
          unless Jolly::Validators::ReturnType.valid(value, instance_variable_get("@return_type_#{method}"))
            raise Jolly::Exceptions::Runtime::Return, "Value returned by #{method} is not the right type"
          end
          value
        end

        # Make it private
        jolly.__eigenclass.send(:private, :__check_return_type)

        # Call the correct instance variable on the scope and return the result
        jolly.__eigenclass.send(:define_method, :perform) do |method, scope|
          scope.__eigenclass.send(:define_method, :__perform, instance_variable_get("@perform_#{method}"))
          return __check_return_type(scope.__perform)
        end
      end
    end
  end
end
