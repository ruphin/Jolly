module Jolly
  module API
    def self.create(module_name, &definition)
      build_context = Jolly::Runtime::Context.new(module_name)
      build_context.__compile__(&definition)
    end
  end
end
