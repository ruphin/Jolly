require 'jolly'
Jolly::API.create 'US::Test' do
  authentication_override do
    puts 'OVERRIDE'
  end
  describe 'get', 'Gets an Object'
  returns Object
  param :id, Integer, multiple: true, optional: true
  param :name, String, multiple: true, optional: true
  perform do
    return US::Models::Test.find(id)
  end
  present do
    { id: test.id, name: test.name }
  end
end
