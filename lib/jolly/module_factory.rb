module Jolly
  class ModuleFactory
    include Jolly::DSL::Api

    def initialize(module_name)
      module_chain = module_name.split('::')
      api_module = module_chain.pop

      parent_module = module_chain.inject(Object) do |parent, constant|
        begin
          parent.const_get(constant)
        rescue NameError
          parent.const_define(constant, Module.new)
        end
      end

      parent_module.const_define(api_module, Module.new)
      @__module__ = parent_module.const_get(api_module)
      @__internal__ = {}
    end

    def __populate__(&definition)
      instance_eval(&definition)
    end

    def __compile__
      @__internal__.each do |mthd, proc|
        @__module__.define_method(mthd, proc)
      end
    end
  end
end
