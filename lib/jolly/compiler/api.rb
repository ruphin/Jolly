module Jolly
  module Compiler
    module API
      def self.compile(mdl, configuration)
        configuration[:methods].keys.each do |method|
        # Define the API methods on the module
          mdl.send(:define_singleton_method, method) do |params|
            # When a method is called, create a new scope
            scope = Jolly::Runtime::Scope.new

            # Define the parameters on the scope
            __jolly__.define_parameters(method, scope, params)

            # Perform the method on the scope, extracting a response
            response = __jolly__.perform(method, scope)

            # Serialize the response
            # __jolly__.serialize(response)
          end
        end
      end
    end
  end
end
