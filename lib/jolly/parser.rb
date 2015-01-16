module Jolly
  module Parser
    def self.parse(&definition)
      # Create a new Context for parsing this API definition
      context = Jolly::Parser::Context.new()

      # Load the Jolly DSL in this context
      context.include(Jolly::Parser::DSL)

      # This executes the definition of the API within the context.
      # The methods defined in Jolly::Parser::DSL are available in the definition block
      # They build a configuration reference for the Jolly Compiler in @config
      context.instance_eval(&definition)

      # Return the configuration for the Jolly Compiler
      return context.instance_variable_get("@config")
    end
  end
end
