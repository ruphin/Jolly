module Jolly
  module Parser
    module Parameters
      def param(name, type, properties)
        parameters = @current[:parameters] ||= []

        parameters.push(name: name, type: type, properties: properties)
      end
    end
  end
end
