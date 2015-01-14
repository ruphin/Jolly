module Jolly
  module Parser
    module Describe
      def describe(name, description = nil)
        __close_description if @current
        __open_description(name)

        @current[:description] = description || "Method #{name}"
      end
    end
  end
end
