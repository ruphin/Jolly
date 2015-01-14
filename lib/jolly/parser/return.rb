module Jolly
  module Parser
    module Return
      def returns(type)
        __unique_option(:return, 'A description can only have one return type')
        @current[:return] = type
      end
    end
  end
end
