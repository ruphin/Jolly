require 'active_support'
require 'active_support/core_ext/string/inflections'

module Jolly
  module Parser
    module Parameters
      def param(name, type, properties = {})
        unless @current
          raise Jolly::Exceptions::InvalidFormat, 'Cannot define a parameter outside a method description'
        end
        parameters = @current[:parameters] ||= {}

        if parameters.key?(name)
          raise Jolly::Exceptions::InvalidName, "There already exists a '#{name}' method in this API"
        end

        multiple = properties.delete(:multiple)
        required = properties.delete(:required)
        parameters[name] = { type: type, properties: properties }

        if multiple
          multiple_name = name.to_s.pluralize
          param(multiple_name, [type], properties)
          parameters[name][:multiple] = multiple_name
          name = [name, multiple_name]
        end

        if required
          exactly_one_of(name) if required
        elsif multiple
          at_most_one_of(name)
        end
      end

      def at_least_one_of(*params)
        __parameter_condition(:atleast_one, params)
      end

      def exactly_one_of(*params)
        __parameter_condition(:exactly_one, params)
      end

      def at_most_one_of(*params)
        __parameter_condition(:atmost_one, params)
      end

      def __parameter_condition(condition, params)
        conditions = @config[:conditions] ||= []
        conditions.push condition: condition, parameters: params.flatten
      end
    end
  end
end
