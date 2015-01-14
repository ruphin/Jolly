module Jolly
  module Parser
    module Authentication
      def authenticate(&block)
        __unique_option(:authenticate, 'A description can only have one authenticate block')
        @current[:authenticate] = block
      end

      def authentication_override(&block)
        if @current
          raise Jolly::Exceptions::InvalidFormat, 'Place Autentication overrides before descriptions'
        end
        overrides = @config[:authentication_overrides] ||= []
        overrides.push(block)
      end
    end
  end
end
