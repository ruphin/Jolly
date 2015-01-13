module Jolly
  module DSL
    module Parameters
      def params(name, type, properties)
        puts "Attempted to define parameters with name:#{name} " \
             "type:#{type} properties:#{properties}"
      end
    end
  end
end
