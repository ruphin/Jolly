require_relative 'helpers'
require_relative 'describe'
require_relative 'return'
require_relative 'parameters'
require_relative 'authentication'
require_relative 'perform'
require_relative 'present'

module Jolly
  module DSL
    include Jolly::Parser::Helpers
    include Jolly::Parser::Describe
    include Jolly::Parser::Return
    include Jolly::Parser::Parameters
    include Jolly::Parser::Authentication
    include Jolly::Parser::Perform
    include Jolly::Parser::Present
  end
end
