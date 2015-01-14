module Jolly
  module Parser
    module Perform
      def perform(&block)
        __unique_option(:perform, 'A description can only have one perform block')
        @current[:perform] = block
      end
    end
  end
end
