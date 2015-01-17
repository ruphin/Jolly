module Jolly
  module Runtime
    class Scope
      def __eigenclass
        class << self
          self
        end
      end

      def method_missing(*)
        nil
      end
    end
  end
end
