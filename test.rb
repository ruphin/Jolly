require 'jolly'
require 'pp'

module US
  module Models
    class User
      @@users = []
      attr_accessor :id, :name
      def initialize(args)
        args.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end
        @@users.push(self)
      end
      def self.find(id)
        return @@users.find {|user| user.id == id}
      end
      def organisations
        Organisation.find_by_user_id(@id)
      end
    end

    class Organisation
      @@orgs = []
      attr_accessor :id, :name, :users
      def initialize(args)
        args.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end
        @@orgs.push(self)
        @users = []
      end
      def self.find(id)
        return @@orgs.find {|org| org.id == id }
      end
      def self.find_by_user_id(user_id)
        return @@orgs.select {|org| org.users.include? user_id }
      end
      def add_user(user_id)
        @users.push(user_id)
      end
    end
  end
end

module US
  module Models
    User.new(id: 1, name: "Goffert")
    User.new(id: 2, name: "Tinco")
    ph = Organisation.new(id: 1, name: "phusion")
    ph.add_user(1)
    ph.add_user(2)
    ut = Organisation.new(id: 2, name: "UTwente")
    ut.add_user(1)
  end
end

config = Jolly::API.create 'US::API::Organisation' do
  authentication_override do
    puts 'OVERRIDE'
  end

  describe 'get'
  returns [US::Models::Organisation]
  param :id, Integer, multiple: true
  param :name, String
  exactly_one_of :id, :name
  perform do
    user = US::Models::Organisation.find(id)
    return user
  end
  serialize do
    { id: test.id, name: test.name }
  end
end

config = Jolly::API.create 'US::API::User' do
  authentication_override do
    puts 'OVERRIDE'
  end

  describe 'organisation'
  returns [US::Models::Organisation]
  param :id, Integer, multiple: true
  param :name, String
  exactly_one_of :id, :name
  perform do
    user = US::Models::User.find(id)
    return user.organisations
  end
  serialize do
    { id: test.id, name: test.name }
  end


  describe 'get'
  returns [US::Models::User]
  param :id, Integer, multiple: true
  param :name, String
  param :organisation, US::API::Organisation, method: :get
  exactly_one_of :id, :name, :organisation
  perform do
    user = US::Models::User.find(id)
    return user
  end
  serialize do
    { id: test.id, name: test.name }
  end
end

p US::API::User.organisation(id: 1) # [Phusion, UTwente]
p US::API::User.get({organisation: {id: 1}}) # [Tinco, Goffert]
p US::API::User.get({id: 1}) # [Goffert]
p US::API::User.get({ids: [1,2,3]}) # [Goffert, Tinco]
p US::API::User.get({id: 3}) # []
p US::API::Organisation.get({ids: [2]}) # [UTwente]
p US::API::User.get({derp: 5}) # Parameter Exceptie
