module Jolly
  module Parser
    module DSL
      include Jolly::Parser::Helpers
      include Jolly::Parser::Describe
      include Jolly::Parser::Return
      include Jolly::Parser::Parameters
      include Jolly::Parser::Authentication
      include Jolly::Parser::Perform
      include Jolly::Parser::Serialize
    end
  end
end
