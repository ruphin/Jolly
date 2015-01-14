module Jolly
  module Parser
    autoload :Helpers,        'jolly/parser/helpers'
    autoload :Describe,       'jolly/parser/describe'
    autoload :Return,         'jolly/parser/return'
    autoload :Parameters,     'jolly/parser/parameters'
    autoload :Authentication, 'jolly/parser/authentication'
    autoload :Perform,        'jolly/parser/perform'
    autoload :Serialize,      'jolly/parser/serialize'
    autoload :DSL,            'jolly/parser/dsl'
  end

  module Exceptions
    autoload :InvalidName,    'jolly/exceptions/invalid_name'
    autoload :InvalidFormat,  'jolly/exceptions/invalid_format'
  end

  module Runtime
    autoload :Context,        'jolly/runtime/context'
    autoload :Scope,          'jolly/runtime/scope'
    autoload :Proxy,          'jolly/runtime/proxy'
  end

  autoload :API,              'jolly/api'
end
