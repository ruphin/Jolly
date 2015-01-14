module Jolly
  module Parser
    module Present
      def present(&block)
        __unique_option(:present, 'A description can only have one present block')
        @current[:present] = block
      end
    end
  end
end
