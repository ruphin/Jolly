module Jolly
  module Exceptions
    autoload :InvalidName,    'jolly/exceptions/invalid_name'
    autoload :InvalidFormat,  'jolly/exceptions/invalid_format'

    module Runtime
      autoload :Parameter,    'jolly/exceptions/runtime/parameter'
    end
  end

  autoload :Parser,           'jolly/parser'
  module Parser
    autoload :Context,        'jolly/parser/context'
    autoload :Helpers,        'jolly/parser/helpers'
    autoload :Describe,       'jolly/parser/describe'
    autoload :Return,         'jolly/parser/return'
    autoload :Parameters,     'jolly/parser/parameters'
    autoload :Authentication, 'jolly/parser/authentication'
    autoload :Perform,        'jolly/parser/perform'
    autoload :Serialize,      'jolly/parser/serialize'
    autoload :DSL,            'jolly/parser/dsl'
  end

  autoload :Compiler,         'jolly/compiler'
  module Compiler
    autoload :Perform,        'jolly/compiler/perform'
    autoload :Parameters,     'jolly/compiler/parameters'
    autoload :API,            'jolly/compiler/api'
  end

  module Runtime
    autoload :Context,        'jolly/runtime/context'
    autoload :Scope,          'jolly/runtime/scope'
    autoload :Jolly,          'jolly/runtime/jolly'
  end

  module Validators
    autoload :Type,           'jolly/validators/type'
  end

  autoload :API,              'jolly/api'
end
