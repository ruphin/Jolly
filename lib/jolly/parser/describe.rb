module Jolly
  module Parser
    module Describe
      def describe(name, description = nil)
        if (@config[:methods] ||= {}).key?(name)
          raise Jolly::Exceptions::InvalidName, "There already exists a '#{name}' method in this API"
        end
        @current = {}
        @config[:methods][name] = @current

        @current[:description] = description || "Method #{name}"
      end
    end
  end
end
