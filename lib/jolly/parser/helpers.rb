module Jolly
  module Parser
    module Helpers
      def __open_description(name)
        puts "Opening #{name} method description"
        if (@config[:methods] ||= {}).key?(name)
          raise Jolly::Exceptions::InvalidName, "There already exists a '#{name}' method in this API"
        end
        @current = { name: name }
      end

      def __close_description
        puts "Ending #{@current[:name]} method description"
        @config[:methods][@current.delete(:name)] = @current
      end

      def __unique_option(key, message)
        raise Jolly::DSL::FormatException, message if @current.key?(key)
      end
    end
  end
end
