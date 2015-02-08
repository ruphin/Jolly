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
      end
    end
  end
end
