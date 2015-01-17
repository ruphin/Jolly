module Jolly
  module Compiler
    module API
      def self.compile(mdl, configuration)
        # # Open the eigenclass for the module
        # eigenclass = class << mdl; self; end

        # # Define the API methods on the module.
        # configuration[:methods].keys.each do |method|
        #   eigenclass.send(:define_method, method) do |params|
        #     # When a method is called, create a new scope
        #     scope = Jolly::Runtime::Scope.new

        #     # Define the parameters
        #     __jolly__.define_params(method, scope, params)
        #     __jolly__.perform(method, scope)
        #   end
        # end

        configuration[:methods].keys.each do |method|
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
