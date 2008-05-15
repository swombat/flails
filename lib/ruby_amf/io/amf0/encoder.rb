module RubyAMF
  module IO
    module AMF0
      class Encoder

        attr_reader :stream
        
        def initialize(stream="")
          @stream   = stream
          @writer   = RubyAMF::IO::Util::BigEndianWriter.new(@stream)
          @context  = RubyAMF::IO::AMF0::Context.new
        end
        
        def stream=(stream)
          @stream = stream
          @writer.stream = @stream
          @context  = RubyAMF::IO::AMF0::Context.new
        end
        
        def encode(value, write_type=true)
          case value
          when Numeric                            : encode_number           value, write_type
          when TrueClass                          : encode_boolean          value, write_type
          when FalseClass                         : encode_boolean          value, write_type
          when String                             : encode_string           value, write_type
          when nil                                : encode_nil
          when RubyAMF::IO::Util::UndefinedType   : encode_undefined_type
          when Hash                               : encode_hash             value, write_type
          when Array                              : encode_array            value, write_type
          when Flails::App::Model::Renderable     : encode_renderable       value, write_type
          end
        end
        
        def encode_number(value, write_type=true)
          @writer.write(:uchar, RubyAMF::IO::AMF0::Types::NUMBER) if write_type
          @writer.write(:double, value)
        end
        
        def encode_boolean(value, write_type=true)
          @writer.write(:uchar, RubyAMF::IO::AMF0::Types::BOOL) if write_type
          @writer.write(:uchar, (value ? 0x01 : 0x00))
        end
        
        def encode_string(value, write_type=true)
          if value.length > 0xffff
            @writer.write(:uchar, RubyAMF::IO::AMF0::Types::LONGSTRING) if write_type
            @writer.write(:ulong, value.length)
          else
            @writer.write(:uchar, RubyAMF::IO::AMF0::Types::STRING) if write_type
            @writer.write(:ushort, value.length)
          end
          @writer.write(:string, value)
        end
        
        def encode_nil(value=nil)
          @writer.write(:uchar, RubyAMF::IO::AMF0::Types::NULL)
        end
        
        def encode_undefined_type(value=RubyAMF::IO::Util::UndefinedType)
          @writer.write(:uchar, RubyAMF::IO::AMF0::Types::UNDEFINED)
        end
        
        def encode_hash(value, write_type=true)
          if @context.has_reference_for?(value)
            encode_reference(value)
            return
          end
          
          @context.add_object(value)
          
          @writer.write(:uchar, RubyAMF::IO::AMF0::Types::OBJECT) if write_type
          value.each do |key, val|
            encode_string(key, false)
            encode(val)
          end
          
          @writer.write(:ushort, 0)
          @writer.write(:uchar, RubyAMF::IO::AMF0::Types::OBJECTTERM)
        end
        
        def encode_reference(value)
          @writer.write(:uchar, RubyAMF::IO::AMF0::Types::REFERENCE)
          @writer.write(:ushort, @context.get_reference(value))
        end
        
        def encode_array(value, write_type=true)
          if @context.has_reference_for?(value)
            encode_reference(value)
            return
          end
          
          @context.add_object(value)
          
          @writer.write(:uchar, RubyAMF::IO::AMF0::Types::ARRAY)
          @writer.write(:ulong, value.length)
          value.each do |val|
            encode(val)
          end
        end
        
        def encode_renderable(value, write_type=true)
          if @context.has_reference_for?(value)
            encode_reference(value)
            return
          end
          
          @context.add_object(value)
          
          if (value.class_name.nil?)
            encode_hash(value.renderable_attributes)
          else
            @writer.write(:uchar, RubyAMF::IO::AMF0::Types::TYPEDOBJECT)
            encode_string(value.class_name, false)
            encode_hash(value.renderable_attributes, false)
          end
        end
        
      end
    end
  end
end