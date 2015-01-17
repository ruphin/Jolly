require 'active_support'
require 'active_support/core_ext/string/inflections'

module Jolly
  module Parser
    module Parameters
      def param(name, type, properties = {})
        parameters = @current[:parameters] ||= {}

        if parameters.key?(name)
          raise Jolly::Exceptions::InvalidName, "There already exists a '#{name}' method in this API"
        end

        multiple = properties.delete(:multiple)
        required = properties.delete(:required)
        definition = { type: type, properties: properties }

        if multiple
          multiple_name = (name.to_s.pluralize).to_sym
          param(multiple_name, [type], properties)
          definition[:multiple] = multiple_name
        end

        parameters[name] = definition

        exactly_one_of name if required
        at_most_one_of name if multiple
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
        parameters = @current[:parameters] ||= {}
        conditions = @config[:conditions] ||= []
        param_list = params.map do |param|
          list = [param]
          list.push parameters[param][:multiple] if parameters[param].key?(:multiple)
        end.flatten

        conditions.push condition: condition, parameters: param_list
      end
    end
  end
end
