require 'activesupport'

module Flails
  module IO
    module AMF3
      class Encoder

        attr_reader :stream
        
        #=====================
        # Initialization and parameters
        def initialize(stream="")
          @stream   = stream
          @writer   = Flails::IO::Util::BigEndianWriter.new(@stream)
          @context  = Flails::IO::AMF3::Context.new
        end
        
        def stream=(stream)
          @stream = stream
          @writer.stream = @stream
          @context  = Flails::IO::AMF3::Context.new
        end
        
        #=====================
        # Key interface
        def encode(value, include_type=true)
          case value
          when Numeric                            : encode_number           value, include_type
          when Flails::IO::Util::UndefinedType    : encode_undefined_type
          when nil                                : encode_nil
          when TrueClass                          : encode_boolean          value
          when FalseClass                         : encode_boolean          value
          when String                             : encode_string           value, include_type
          end
        end
        
        #=====================
        # Primitives
        def encode_number(value, include_type=true)
          if value.integer? && (-0x10000000..0xfffffff).member?(value)
            @writer.write(:uchar, Flails::IO::AMF3::Types::INTEGER) if include_type
            @writer.write(:vlint, value)
          else
            @writer.write(:uchar, Flails::IO::AMF3::Types::NUMBER) if include_type
            @writer.write(:double, value)
          end
        end

        #=====================
        # Strings
        def encode_string(value, include_type=true)
          @writer.write(:uchar, Flails::IO::AMF3::Types::STRING) if include_type

          return if try_reference(value, :strings) if include_type && value.length != 0

          @writer.write(:vlint, (value.length << 1) + 1)
          @writer.write(:string, value)
        end

        #=====================
        # Special values
        def encode_nil(value=nil)
          @writer.write(:uchar, Flails::IO::AMF3::Types::NULL)
        end
        
        def encode_undefined_type(value=Flails::IO::Util::UndefinedType)
          @writer.write(:uchar, Flails::IO::AMF3::Types::UNDEFINED)
        end

        def encode_boolean(value=false)
          @writer.write(:uchar, value ? Flails::IO::AMF3::Types::BOOL_TRUE : Flails::IO::AMF3::Types::BOOL_FALSE)
        end
        
        def encode_reference(value, subcontext)
          @writer.write(:vlint, subcontext.get_reference(value) << 1)
        end

      private
        # Tries the reference and returns true if the reference was encoded. Otherwise adds
        # the reference and returns false. This code was extracted to DRY out the encoding methods.
        def try_reference(value, subcontext)
          @subcontext = @context.send(subcontext)
          if @subcontext.has_reference_for?(value)
            encode_reference(value, subcontext)
            return true
          else
            @subcontext.add(value)
            return false
          end
        end
        
      end
    end
  end
end