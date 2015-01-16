module Jolly
  module Runtime
    class Jolly
      def __eigenclass
        class << self
          self
        end
      end
    end
  end
end
