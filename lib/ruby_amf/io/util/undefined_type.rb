module RubyAMF
  module IO
    module Util
      # This class exists for the sole purpose of providing something that can be passed to the AMF encoder to represent an undefined
      # type, since this concept is unknown in ruby.
      class UndefinedType
      end
    end
  end
end