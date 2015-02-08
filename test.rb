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
      def self.find_by_id(id)
        return @@users.select { |user| user.id == id }
      end
      def self.find_ny_name(name)
        return @@users.select { |user| user.name == name }
      end
      def organisations
        Organisation.find_by_user_id(id)
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
      def self.find_by_id(id)
        return @@orgs.select { |org| org.id == id }
      end
      def self.find_by_name(name)
        return @@orgs.select { |org| org.name == name }
      end
      def self.find_by_user_id(user_id)
        return @@orgs.select { |org| org.users.include? user_id }
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

Jolly::API.create 'US::API::Organisation' do
  authentication_override do
    puts 'OVERRIDE'
  end

  describe 'get'
  returns [US::Models::Organisation]
  param :id, Integer, multiple: true
  param :name, String
  exactly_one_of :id, :name
  perform do
    if id
      organisations = US::Models::Organisation.find_by_id(id)
    elsif name
      organisations = US::Models::Organisation.find_by_name(name)
    end
    return organisations
  end
  serialize do
    { id: id, name: name }
  end
end

Jolly::API.create 'US::API::User' do
  authentication_override do
    puts 'OVERRIDE'
  end

  describe 'get'
  returns [US::Models::User]
  param :id, Integer, multiple: true
  param :name, String
  param :organisations, US::API::Organisation, method: :get
  exactly_one_of :id, :name, :organisations
  perform do
    if id
      users = US::Models::User.find_by_id(id)
    elsif name
      users = US::Models::User.find_by_name(name)
    elsif organisations
      # What do we want here? Is organisations the validated param hash? Or the value return by perform?
      users = true
    end
    return users
  end
  serialize do
    { id: id, name: name }
  end
end

pp US::API::User.get({id: 1}) # [Goffert]
pp US::API::User.get({organisations: {id: 1}}) # [Tinco, Goffert]
pp US::API::User.get({ids: [1,2,3]}) # [Goffert, Tinco]
pp US::API::User.get({id: 3}) # []
pp US::API::Organisation.get({ids: [2]}) # [UTwente]
pp US::API::User.get({derp: 5}) # Parameter Exceptie
