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
          when Numeric                            : encode_number(value)
          when TrueClass                          : encode_boolean(value)
          when FalseClass                         : encode_boolean(value)
          when String                             : encode_string(value)
          when nil                                : encode_nil(value)
          when RubyAMF::IO::Util::UndefinedType   : encode_undefined_type(value)
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
        
        def encode_string(value)
          if value.length > 0xffff
            @stream << RubyAMF::IO::AMF0::Types::LONGSTRING
            @writer.write(:ulong, value.length)
          else
            @stream << RubyAMF::IO::AMF0::Types::STRING
            @writer.write(:ushort, value.length)
          end
          @writer.write(:string, value)
        end
        
        def encode_nil(value=nil)
          @stream << RubyAMF::IO::AMF0::Types::NULL
        end
        
        def encode_undefined_type(value=RubyAMF::IO::Util::UndefinedType)
          @stream << RubyAMF::IO::AMF0::Types::UNDEFINED
        end
        
      end
    end
  end
end