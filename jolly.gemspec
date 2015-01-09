$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'jolly/version'

Gem::Specification.new do |s|
  s.name        = 'jolly'
  s.version     = Jolly::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Goffert van Gool']
  s.email       = 'goffert@phusion.nl'
  s.homepage    = 'http://rubygems.org/gems/jolly'
  s.summary     = 'A DSL for constructing Javascript API layers'
  s.description = 'A DSL for constructing Javascript API layers'
  s.license     = 'MIT'

  s.files       = ['lib/jolly.rb', 'lib/jolly/api.rb']
end
