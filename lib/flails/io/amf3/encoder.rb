require 'activesupport'

module Flails
  module IO
    module AMF3
      class Encoder

        attr_reader :stream, :writer
        attr_accessor :array_collection_type
        
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
          case
          when value.is_a?(Numeric)                           : encode_number           value, include_type
          when value.is_a?(Flails::IO::Util::UndefinedType)   : encode_undefined_type
          when value.nil?                                     : encode_nil
          when value.is_a?(TrueClass)                         : encode_boolean          value
          when value.is_a?(FalseClass)                        : encode_boolean          value
          when value.is_a?(String)                            : encode_string           value, include_type
          when value.is_a?(Array)                             : array_collection_type.blank? ? encode_array(value, include_type) : encode_array_collection(value)
          when value.is_a?(Hash)                              : encode_hash             value.stringify_keys, include_type
          when value.is_a?(Time)                              : encode_date             value, include_type
          when value.is_a?(Date)                              : encode_date             value.to_time, include_type
          when value.is_a?(DateTime)                          : encode_date             value.to_time, include_type
          when value.is_a?(Flails::App::Model::Renderable)    : encode_renderable       value, include_type
          else
            raise InvalidInputException, "Unknown AMF Type: Cannot render #{value.inspect}"
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

          return if try_reference(value, :strings) if value.length != 0

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
        
        def encode_reference(value, subcontext, subcontext_symbol)
          
          if subcontext_symbol == :classes
            shift, add = 2, 1
          else
            shift, add = 1, 0
          end
          
          @writer.write(:vlint, (subcontext.get_reference(value) << shift) + add)
        end
        
        #=====================
        # Dates
        def encode_date(value, include_type=true)
          timezone = 0
          
          @writer.write(:uchar, Flails::IO::AMF3::Types::DATE) if include_type
          
          return if try_reference(value, :objects)
          
          @writer.write(:uchar, 0x01)
          @writer.write(:double, value.to_f * 1000.0)
        end
        
        #=====================
        # Arrays and Hashes
        # Note: Hashes are assumed to be entirely composed of associative key-value pairs,
        # with no mixed array+hash type, as such a type does not make sense in Ruby.
        def encode_hash(value, include_type=true)
          @writer.write(:uchar, Flails::IO::AMF3::Types::ARRAY) if include_type

          return if try_reference(value, :objects)

          # The AMF3 spec demands that all str based indices be listed first
          @writer.write(:vlint, 0x01) # (int_values.length << 1) + 1 === 0x01

          value.each do |key, val|
            raise Flails::IO::InvalidInputException, "Cannot render Hash with empty string key" if key == ""
            encode_string(key, false)
            encode(val)
          end

          @writer.write(:uchar, 0x01)
        end        
        
        def encode_array(value, include_type=true)
          @writer.write(:uchar, Flails::IO::AMF3::Types::ARRAY) if include_type

          return if try_reference(value, :objects)

          @writer.write(:vlint, (value.length << 1) + 1)
          @writer.write(:uchar, 0x01)
          
          value.each do |v|
            self.encode(v)
          end
        end

        def encode_array_collection(value) # no include_type, as it makes no sense here
          @writer.write(:uchar, Flails::IO::AMF3::Types::OBJECT)

          try_reference(Flails::IO::Util::ReferenceWrapper.new(value), :objects)
          
          unless try_reference(array_collection_type, :classes)
            @writer.write(:uchar, 0x01 | (0x01 << 1) | (0x01 << 2)) # U290-traits-ext
            self.encode_string array_collection_type, false
          end
          
          self.encode_array value
        end
        
        #=====================
        # Objects
        def encode_renderable(value, include_type=true)
          @writer.write(:uchar, Flails::IO::AMF3::Types::OBJECT) if include_type
          
          return if try_reference(value, :objects)
          
          class_definition = Flails::IO::Util::ClassDefinition::get(value)
          self.encode_class_definition class_definition

          if class_definition.static?
            class_definition.attributes.each do |key|
              self.encode(value.renderable_attributes[key])
            end
          elsif class_definition.dynamic?
            class_definition.attributes.each do |key|
              self.encode_string(key.to_s, false)
              self.encode(value.renderable_attributes[key])
            end
            @writer.write(:uchar, 0x01)
          end
          
        end
        
        def encode_class_definition(class_definition)
          unless try_reference(class_definition, :classes)
            @writer.write(:vlint,   (class_definition.sealed_attributes_count << 4) |
                                    (class_definition.encoding << 2) |
                                    (0x01 << 1) |
                                    0x01)
            self.encode_string(class_definition.flex_class_name || "", false)
            
            if class_definition.encoding == Flails::IO::AMF3::Types::OBJECT_STATIC
              class_definition.attributes.each do |key|
                self.encode_string(key.to_s, false)
              end
            end
          end          
        end

      private
        # Tries the reference and returns true if the reference was encoded. Otherwise adds
        # the reference and returns false. This code was extracted to DRY out the encoding methods.
        def try_reference(value, subcontext_symbol)
          subcontext = @context.send(subcontext_symbol)
          if subcontext.has_reference_for?(value)
            RAILS_DEFAULT_LOGGER.debug "\nFound reference for '#{value.inspect}' in #{subcontext.inspect}\n\n"
            encode_reference(value, subcontext, subcontext_symbol)
            return true
          else
            subcontext.add(value)
            return false
          end
        end
        
      end
    end
  end
end