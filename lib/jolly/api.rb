module Jolly
  module API
    def create(module_name, &definition)
      factory = Jolly::ModuleFactory.new(module_name)
      factory.__populate__(&definition)
      factory.__compile__
    end
  end
end
