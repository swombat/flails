module RubyAMF
  module IO
    module Util
      # This BinaryEncoder is BigEndian (aka NetworkEndian). It does not support LittleEndian encoding,
      # but can deal with a situation where the machine it is running on is LittleEndian by default, and
      # correct for that.
      class BigEndianWriter

        BIG_ENDIAN      = 1
        NETWORK_ENDIAN  = 1 # same as BIG_ENDIAN
        LITTLE_ENDIAN   = 2
        
        TYPES = {
          :char       => 'C',
          :uchar      => 'c',
          :short      => 'n',
          :ushort     => 'n',
          :long       => 'N',
          :ulong      => 'N',
          :int        => 'N',
          :uint       => 'N',
          :float      => 'g',
          :double     => 'G'
        }

        attr_accessor :stream
        attr_accessor :local_byte_order
        
        def initialize(stream="")
          @stream = stream
          @local_byte_order = local_big_endian? ? BIG_ENDIAN : LITTLE_ENDIAN
        end
        
        def write(type, value, stream=@stream)
          stream << [value].pack(TYPES[type])
        end
        
      private
        def local_big_endian?
          [0x12345678].pack("L") == "\x12\x34\x56\x78"
        end
      end
    end
  end
end