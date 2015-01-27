module Jolly
  module Parser
    class Context
      include Jolly::Parser::DSL

      def initialize
        @config = { methods: {} }
      end
    end
  end
end
