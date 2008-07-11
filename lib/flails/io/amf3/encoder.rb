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
          end
        end
        
        #=====================
        # Primitives
        def encode_number(value, include_type=true)
          if value.integer?
            @writer.write(:uchar, Flails::IO::AMF3::Types::INTEGER) if include_type
            @writer.write(:vlint, value)
          end
        end
        
      end
    end
  end
end