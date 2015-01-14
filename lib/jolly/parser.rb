require_relative 'parser/helpers'
require_relative 'parser/describe'
require_relative 'parser/return'
require_relative 'parser/parameters'
require_relative 'parser/authentication'
require_relative 'parser/perform'
require_relative 'parser/present'

module Jolly
  module Parser
    include Jolly::Parser::Helpers
    include Jolly::Parser::Describe
    include Jolly::Parser::Return
    include Jolly::Parser::Parameters
    include Jolly::Parser::Authentication
    include Jolly::Parser::Perform
    include Jolly::Parser::Present
  end
end
