module Jolly
  module Parser
    class Context
      include Jolly::Parser::DSL

      def initialize
        @config = {}
      end
    end
  end
end
