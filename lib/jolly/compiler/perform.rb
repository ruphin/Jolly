module Jolly
  module Compiler
    module Perform
      def self.compile(jolly, configuration)
        # Define the methods as instance variables
        configuration[:methods].each do |method, definition|
          jolly.instance_variable_set("@perform_#{method}", definition[:perform])
        end

        # Define the return types as instance variables
        configuration[:methods].each do |method, definition|
          if definition[:return]
            jolly.instance_variable_set("@return_type_#{method}", definition[:return])
          end
        end

        # Define a private method that raises an exception if the return type is not correct
        jolly.__eigenclass.send(:private, :__check_return_type) do |method, value|
          if !Jolly::Validators::ReturnType.valid(value, instance_variable_get("@return_type_#{method}"))
            raise Jolly::Exceptions::Runtime::Return, "Value returned by #{method} is not the right type"
          end
          value
        end

        # Call the correct instance variable on the scope and return the result
        jolly.__eigenclass.send(:define_method, :perform) do |method, scope|
          scope.__eigenclass.send(:define_method, :__perform, instance_variable_get("@perform_#{method}"))
          return __check_return_type(scope.__perform)
        end
      end
    end
  end
end
