require 'active_support/concern'

module Jolly
  module DSL
    module API
      extend ActiveSupport::Concern

      include Jolly::DSL::Parameters
    end
  end
end
