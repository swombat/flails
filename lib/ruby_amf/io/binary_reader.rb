module RubyAMF
  module IO
    module BinaryReader
      include RubyAMF::App
    
      Native = :Native
      Big = BigEndian = Network = :BigEndian
      Little = LittleEndian = :LittleEndian
  
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
  
      #read N length from stream starting at position
      def readn(length)
        self.stream_position ||= 0
        str = self.stream[self.stream_position, length]
        self.stream_position += length
        str
      end
  
      #reada a boolean
      def read_boolean
        d = self.stream[self.stream_position,1].unpack('c').first
        self.stream_position += 1
        (d == 1) ? true : false;
      end
  
      #8bits no byte order
      def read_int8
        d = self.stream[self.stream_position,1].unpack('c').first
        self.stream_position += 1
        d
      end
      alias :read_byte :read_int8  
  
      # Aryk: TODO: This needs to be written more cleanly. Using rescue and then regex checks on top of that slows things down
      def read_word8
        begin
          d = self.stream[self.stream_position,1].unpack('C').first
          self.stream_position += 1
          d
        rescue Exception => e
          #this handles an exception condition when Rails' 
          #ActionPack strips off the last "\000" of the AMF stream
          self.stream_position += 1
          return 0
        end
      end
  
      #16 bits Unsigned
      def read_word16_native
        d = self.stream[self.stream_position,2].unpack('S').first
        self.stream_position += 2
        d
      end
  
      def read_word16_little
        d = self.stream[self.stream_position,2].unpack('v').first
        self.stream_position += 2
        d
      end

      def read_word16_network
        d = self.stream[self.stream_position,2].unpack('n').first
        self.stream_position += 2
        d
      end
  
      #16 bits Signed
      def read_int16_native
        str = self.readn(2).unpack('s').first
      end
  
      def read_int16_little
        str = self.readn(2)
        str.reverse! if byte_order_network? # swap bytes as native=network (and we want little)
        str.unpack('s').first
      end
  
      def read_int16_network
        str = self.readn(2)
        str.reverse! if byte_order_little? # swap bytes as native=little (and we want network)
        str.unpack('s').first
      end
  
      #32 bits unsigned
      def read_word32_native
        d = self.stream[self.stream_position,4].unpack('L').first
        self.stream_position += 4
        d
      end

      def read_word32_little
        d = self.stream[self.stream_position,4].unpack('V').first
        self.stream_position += 4
        d
      end
  
      def read_word32_network
        d = self.stream[self.stream_position,4].unpack('N').first
        self.stream_position += 4
        d
      end
  
      #32 bits signed
      def read_int32_native
        d = self.stream[self.stream_position,4].unpack('l').first
        self.stream_position += 4
        d
      end
  
      def read_int32_little
        str = readn(4)
        str.reverse! if byte_order_network? # swap bytes as native=network (and we want little)
        str.unpack('l').first
      end
  
      def read_int32_network
        str = readn(4)
        str.reverse! if byte_order_little? # swap bytes as native=little (and we want network)
        str.unpack('l').first
      end
  
  
      #UTF string
      def read_utf
        length = self.read_word16_network
        readn(length)
      end
  
      def read_int32_network
        str = self.readn(4)
        str.reverse! if byte_order_little? # swap bytes as native=little (and we want network)
        str.unpack('l').first
      end
  
      def read_double
        d = self.stream[self.stream_position,8].unpack('G').first
        self.stream_position += 8
        d
      end
  
      def read_long_utf(length)
        length = read_word32_network #get the length of the string (1st 4 bytes)
        self.readn(length) #read length number of bytes
      end
    end
  end
end