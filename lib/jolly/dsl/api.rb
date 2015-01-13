require 'active_support/concern'
require_relative 'parameters'

module Jolly
  module DSL
    module API
      extend ActiveSupport::Concern

      include Jolly::DSL::Parameters
    end
  end
end



US::API::Users.find(actor, params)

US::API::Users.as(actor).find(params)

Users = US::API::Users.as(actor)

Users.find(params)

US::API::Users.find(params)

class ActorProxy
	def initialize(mod, actor)
		@mod = mod
		@actor = actor
	end

	def method_missing(*args, &block)
		mod.send([actor]+args, &block)
	end
end

module Bla
	def self.as(actor)
		ActorProxy.new(self, actor)
	end
end
