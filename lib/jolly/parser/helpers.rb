module Jolly
  module Parser
    module Helpers
      def __unique_option(key, message)
        raise Jolly::DSL::FormatException, message if @current.key?(key)
      end
    end
  end
end
