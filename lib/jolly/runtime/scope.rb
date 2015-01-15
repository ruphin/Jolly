module Jolly
  module Runtime
    class Scope < BasicObject
      def method_missing
        return nil
      end
    end
  end
end
