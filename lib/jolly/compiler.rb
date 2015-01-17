module Jolly
  module Compiler
    # Called to compile the configuration into a Module.
    def self.compile(mdl, configuration)
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

      Parameters.compile(jolly, configuration)
      Perform.compile(jolly, configuration)
      API.compile(mdl, configuration)
    end
  end
end
