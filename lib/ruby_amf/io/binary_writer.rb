module RubyAMF
  module IO
    module BinaryWriter
    
      #examines the locale byte order on the running machine
      def byte_order
        if [0x12345678].pack("L") == "\x12\x34\x56\x78" 
          :BigEndian
        else
          :LittleEndian
        end
      end
  
      def byte_order_little?
        (byte_order == :LittleEndian) ? true : false;
      end
  
      def byte_order_big?
        (byte_order == :BigEndian) ? true : false;
      end
      alias :byte_order_network? :byte_order_big?
  
      def writen(val)
        @stream << val
      end
  
      #8 bit no byteorder
      def write_word8(val)
        self.stream << [val].pack('C')
      end

      def write_int8(val)
        self.stream << [val].pack('c')
      end

      #16 bit unsigned
      def write_word16_native(val)
        self.stream << [val].pack('S')
      end
  
      def write_word16_little(val)
        str = [val].pack('S')
        str.reverse! if byte_order_network? # swap bytes as native=network (and we want little)
        self.stream << str
      end
  
      def write_word16_network(val)
        str = [val].pack('S')
        str.reverse! if byte_order_little? # swap bytes as native=little (and we want network)
        self.stream << str
      end
  
      #16 bits signed
      def write_int16_native(val)
        self.stream << [val].pack('s')
      end

      def write_int16_little(val)
        self.stream << [val].pack('v')
      end

      def write_int16_network(val)
        self.stream << [val].pack('n')
      end

      #32 bit unsigned
      def write_word32_native(val)
        self.stream << [val].pack('L')
      end

      def write_word32_little(val)
        str = [val].pack('L')
        str.reverse! if byte_order_network? # swap bytes as native=network (and we want little)
        self.stream << str
      end

      def write_word32_network(val)
        str = [val].pack('L')
        str.reverse! if byte_order_little? # swap bytes as native=little (and we want network)
        self.stream << str
      end

      #32 signed
      def write_int32_native(val)
        self.stream << [val].pack('l')
      end
  
      def write_int32_little(val)
        self.stream << [val].pack('V')
      end

      def write_int32_network(val)
        self.stream << [val].pack('N')
      end
  
      # write utility methods
      def write_byte(val)
        #self.write_int8(val)
        @stream << [val].pack('c')
      end

      def write_boolean(val)
        if val then self.write_byte(1) else self.write_byte(0) end
      end

      def write_utf(str)
        self.write_int16_network(str.length)
        self.stream << str
      end
  
      def write_long_utf(str)
        self.write_int32_network(str.length)
        self.stream << str
      end
    
      def write_double(val)
        self.stream << ( @floats_cache[val] ||= 
          [val].pack('G')
        )
        #puts "WRITE DOUBLE"
        #puts @floats_cache
      end
    end
  end
end
