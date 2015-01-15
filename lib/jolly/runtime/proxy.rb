module Jolly
  module Runtime
    class Proxy
      def __eigenclass
        class << self
          self
        end
      end
    end
  end
end
