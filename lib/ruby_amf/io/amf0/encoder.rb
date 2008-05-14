module RubyAMF
  module IO
    module AMF0
      class Encoder

        attr_reader :stream
        
        def initialize(stream="")
          @stream = stream
          @writer = RubyAMF::IO::Util::BigEndianWriter.new(@stream)
        end
        
        def stream=(stream)
          @stream = stream
          @writer.stream = @stream
        end
        
        def encode(value)
          case value
          when Numeric        : encode_number(value)
          when TrueClass      : encode_boolean(value)
          when FalseClass     : encode_boolean(value)
          end
        end
        
        def encode_number(value)
          @stream << RubyAMF::IO::AMF0::Types::NUMBER
          @writer.write(:double, value)
        end
        
        def encode_boolean(value)
          @stream << RubyAMF::IO::AMF0::Types::BOOL
          @writer.write(:uchar, (value ? 0x01 : 0x00))
        end
        
      end
    end
  end
end