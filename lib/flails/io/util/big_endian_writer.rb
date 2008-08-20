module Flails
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
          :double     => 'G',
          :string     => nil
        }
        
        EXTENDED_TYPES = {
          :vlint      => true
        }

        attr_accessor :stream
        attr_accessor :local_byte_order
        
        def initialize(stream="")
          @stream = stream
          @local_byte_order = local_big_endian? ? BIG_ENDIAN : LITTLE_ENDIAN
        end
        
        def write(type, value, stream=@stream)
          unless TYPES[type].nil?
            stream << [value].pack(TYPES[type])
          else 
            unless EXTENDED_TYPES[type].nil?
              extended_write(type, value, stream)
            else
              stream << value
            end
          end
        end
        
        def f_write_vlint(value, stream=@stream)
          value += 0x20000000 if value < 0

          case value
          when 0..0x7f:               stream << [value].pack('c')
          when 0x80..0x3fff:          stream << [0x80 | ((value >> 7) & 0xff)].pack('c') +
                                                [value & 0x7f].pack('c')
          when 0x4000..0x1fffff:      stream << [0x80 | ((value >> 14) & 0xff)].pack('c') +
                                                [0x80 | ((value >> 7) & 0xff)].pack('c') +
                                                [value & 0x7f].pack('c')
          when 0x200000..0x3fffffff:  stream << [0x80 | ((value >> 22) & 0xff)].pack('c') +
                                                [0x80 | ((value >> 15) & 0xff)].pack('c') +
                                                [0x80 | ((value >> 8) & 0xff)].pack('c') +
                                                [value & 0xff].pack('c')
          end
        end
        
        def f_write_string(value, stream=@stream)
          stream << value
        end
        
        def f_write_uchar(value, stream=@stream)
          stream << [value].pack('c')
        end
        
        def f_write_double(value, stream=@stream)
          stream << [value].pack('G')
        end
                
      private
        def local_big_endian?
          [0x12345678].pack("L") == "\x12\x34\x56\x78"
        end

        def extended_write(type, value, stream=@stream)
          write_variable_length_integer(value, stream)
        end

        def write_variable_length_integer(value, stream=@stream)
          value += 0x20000000 if value < 0

          case value
          when 0..0x7f:               stream << [value].pack('c')
          when 0x80..0x3fff:          stream << [0x80 | ((value >> 7) & 0xff)].pack('c') +
                                                [value & 0x7f].pack('c')
          when 0x4000..0x1fffff:      stream << [0x80 | ((value >> 14) & 0xff)].pack('c') +
                                                [0x80 | ((value >> 7) & 0xff)].pack('c') +
                                                [value & 0x7f].pack('c')
          when 0x200000..0x3fffffff:  stream << [0x80 | ((value >> 22) & 0xff)].pack('c') +
                                                [0x80 | ((value >> 15) & 0xff)].pack('c') +
                                                [0x80 | ((value >> 8) & 0xff)].pack('c') +
                                                [value & 0xff].pack('c')
          end
          
          # case value
          # when 0..0x7f:               write(:uchar, value, stream)
          # when 0x80..0x3fff:          write(:uchar, 0x80 | ((value >> 7) & 0xff), stream)
          #                             write(:uchar, value & 0x7f, stream)
          # when 0x4000..0x1fffff:      write(:uchar, 0x80 | ((value >> 14) & 0xff), stream)
          #                             write(:uchar, 0x80 | ((value >> 7) & 0xff), stream)
          #                             write(:uchar, value & 0x7f, stream)
          # when 0x200000..0x3fffffff:  write(:uchar, 0x80 | ((value >> 22) & 0xff), stream)
          #                             write(:uchar, 0x80 | ((value >> 15) & 0xff), stream)
          #                             write(:uchar, 0x80 | ((value >> 8) & 0xff), stream)
          #                             write(:uchar, value & 0xff, stream)
          # end
        end
      end
    end
  end
end