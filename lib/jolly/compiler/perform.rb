module Jolly
  module Compiler
    module Perform
      def self.compile(jolly, configuration)
        configuration[:methods].each do |method, definition|
          # Define the perform methods as instance variables
          jolly.instance_variable_set("@perform_#{method}", definition[:perform])

          # Define the return types as instance variables
          if definition[:return]
            jolly.instance_variable_set("@return_type_#{method}", definition[:return])
          end
        end

        # Define a method that raises an exception if the return type is not correct
        jolly.__eigenclass.send(:define_method, :__check_return_type) do |method, value|
          return_type = jolly.instance_variable_get("@return_type_#{method}")
          if return_type && !Jolly::Validators::Type.check(value, return_type)
            raise Jolly::Exceptions::Runtime::Return, "Value returned by #{method} is not the right type"
          end
          value
        end

        # Make it private
        jolly.__eigenclass.send(:private, :__check_return_type)

        # Call the correct instance variable on the scope and return the result
        jolly.__eigenclass.send(:define_method, :perform) do |method, scope|
          scope.__eigenclass.send(:define_method, :__perform, instance_variable_get("@perform_#{method}"))
          return __check_return_type(method, scope.__perform)
        end
      end
    end
  end
end
