require 'jolly'
Jolly::API.create 'US::API::Test' do
  authentication_override do
    puts 'OVERRIDE'
  end

  describe 'get'
  returns Object
  param :id, Integer, multiple: true, optional: true
  param :name, String, multiple: true, optional: true
  param :organisation, Object, method: :get
  exactly_one_of :id, :name
  perform do
    return US::Models::Test.find(id)
  end
  serialize do
    { id: test.id, name: test.name }
  end
end
