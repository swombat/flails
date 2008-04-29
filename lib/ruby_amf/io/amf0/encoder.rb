module RubyAMF
  module IO
    module AMF0
      class Encoder

        attr_accessor :stream
        
        def initialize(stream="")
          @stream = stream
        end
        
        def encode(value)
          @stream << value
        end
        
      end
    end
  end
end