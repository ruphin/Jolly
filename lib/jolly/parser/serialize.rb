module Jolly
  module Parser
    module Serialize
      def serialize(&block)
        __unique_option(:serialize, 'A description can only have one present block')
        @current[:serialize] = block
      end
    end
  end
end
