require 'activesupport'

module Flails
  module IO
    module AMF0
      class Encoder

        attr_reader :stream
        
        #=====================
        # Initialization and parameters
        def initialize(stream="")
          @stream   = stream
          @writer   = Flails::IO::Util::BigEndianWriter.new(@stream)
          @context  = Flails::IO::AMF0::Context.new
        end
        
        def stream=(stream)
          @stream = stream
          @writer.stream = @stream
          @context  = Flails::IO::AMF0::Context.new
        end
        
        #=====================
        # Key interface
        def encode(value, include_type=true)
          case value
          when Numeric                            : encode_number           value, include_type
          when TrueClass                          : encode_boolean          value, include_type
          when FalseClass                         : encode_boolean          value, include_type
          when String                             : encode_string           value, include_type
          when nil                                : encode_nil
          when Flails::IO::Util::UndefinedType    : encode_undefined_type
          when Hash                               : encode_hash             value, include_type
          when Array                              : encode_array            value, include_type
          when Flails::App::Model::Renderable     : encode_renderable       value, include_type
          when Time                               : encode_date             value, include_type
          when Date                               : encode_date             value.to_time, include_type
          when DateTime                           : encode_date             value.to_time, include_type
          end
        end
        
        #=====================
        # Primitives
        def encode_number(value, include_type=true)
          @writer.write(:uchar, Flails::IO::AMF0::Types::NUMBER) if include_type
          @writer.write(:double, value)
        end
        
        def encode_boolean(value, include_type=true)
          @writer.write(:uchar, Flails::IO::AMF0::Types::BOOL) if include_type
          @writer.write(:uchar, (value ? 0x01 : 0x00))
        end
        
        #=====================
        # Strings
        def encode_string(value, include_type=true)
          if value.length > 0xffff
            @writer.write(:uchar, Flails::IO::AMF0::Types::LONGSTRING) if include_type
            @writer.write(:ulong, value.length)
          else
            @writer.write(:uchar, Flails::IO::AMF0::Types::STRING) if include_type
            @writer.write(:ushort, value.length)
          end
          @writer.write(:string, value)
        end
        
        #=====================
        # Special values
        def encode_nil(value=nil)
          @writer.write(:uchar, Flails::IO::AMF0::Types::NULL)
        end
        
        def encode_undefined_type(value=Flails::IO::Util::UndefinedType)
          @writer.write(:uchar, Flails::IO::AMF0::Types::UNDEFINED)
        end
        
        #=====================
        # References
        def encode_reference(value)
          @writer.write(:uchar, Flails::IO::AMF0::Types::REFERENCE)
          @writer.write(:ushort, @context.get_reference(value))
        end

        #=====================
        # Objects
        def encode_hash(value, include_type=true)
          return if try_reference(value) if include_type
          
          @writer.write(:uchar, Flails::IO::AMF0::Types::OBJECT) if include_type
          value.each do |key, val|
            encode_string(key.to_s, false)
            encode(val)
          end
          
          @writer.write(:ushort, 0)
          @writer.write(:uchar, Flails::IO::AMF0::Types::OBJECTTERM)
        end
        
        def encode_renderable(value, include_type=true)
          return if try_reference(value) if include_type
          
          class_definition = Flails::IO::Util::ClassDefinition.get(value)
          
          if (class_definition.flex_class_name.nil?)
            @writer.write(:uchar, Flails::IO::AMF0::Types::OBJECT) if include_type
          else
            @writer.write(:uchar, Flails::IO::AMF0::Types::TYPEDOBJECT) if include_type
            encode_string(class_definition.flex_class_name, false)
          end

          encode_hash(value.renderable_attributes, false)
        end
        
        #=====================
        # Arrays
        def encode_array(value, include_type=true)
          return if try_reference(value) if include_type
          
          @writer.write(:uchar, Flails::IO::AMF0::Types::ARRAY) if include_type
          @writer.write(:ulong, value.length)
          value.each do |val|
            encode(val)
          end
        end

        #=====================
        # Dates
        def encode_date(value, include_type=true)
          timezone = 0
          
          @writer.write(:uchar, Flails::IO::AMF0::Types::DATE) if include_type
          @writer.write(:double, value.to_f * 1000.0)
          @writer.write(:ushort, timezone)
        end
        
      private
        # Tries the reference and returns true if the reference was encoded. Otherwise adds
        # the reference and returns false. This code was extracted to DRY out the encoding methods.
        def try_reference(value)
          if @context.has_reference_for?(value)
            encode_reference(value)
            return true
          else
            @context.add(value)
            return false
          end
        end
        
      end
    end
  end
end