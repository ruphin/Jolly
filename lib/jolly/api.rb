module Jolly
  module API
    def self.create(module_name, &definition)
      # Parse the definition, returns a configuration for the compiler
      configuration = Jolly::Parser.parse(&definition)

      # Create the new Module
      mdl = create_module(module_name)

      # Compile the Context into the module
      Jolly::Compiler.compile(mdl, configuration)
    end

    private

    def self.create_module(module_name)
      module_chain = module_name.split('::')
      api_module = module_chain.pop

      # Define the containing Module chain
      parent_module = module_chain.inject(Object) do |parent, constant|
        begin
          parent.const_get(constant)
        rescue NameError
          parent.const_set(constant, Module.new)
        end
      end

      # Define the new Module, and return it
      parent_module.const_set(api_module, Module.new)
    end
  end
end
