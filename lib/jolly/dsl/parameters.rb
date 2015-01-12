require 'active_support/concern'

module Jolly
  module DSL
    module Parameters
      extend ActiveSupport::Concern

      module ClassMethods
        def params(name, type, properties)
          puts "Attempted to define parameters with name:#{name} " \
               "type:#{type} properties:#{properties}"
        end
      end
    end
  end
end
