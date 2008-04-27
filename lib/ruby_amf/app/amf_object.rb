module RubyAMF
  module App
    #A High level amf message wrapper with methods for easy header and body manipulation
    class AMFObject

      #raw input stream
      attr_accessor :input_stream
  
      #serialized output stream
      attr_accessor :output_stream
  
      attr_accessor :bodys
    
      #create a new AMFObject, pass the raw request data
      def initialize(rw = nil)
        @input_stream = rw
        @output_stream = "" #BinaryString.new("")
        @inheaders = Array.new
        @outheaders = Array.new
        @bodys = Array.new
        @header_table = Hash.new
      end

      #add a raw header to this amf_object
      def add_header(amf_header)
        @inheaders << amf_header
        @header_table[amf_header.name] = amf_header
      end

      #get a header by it's key
      def get_header_by_key(key)
        @header_table[key]||false
      end

      #get a header at a specific index
      def get_header_at(i=0)
        @inheaders[i]||false
      end

      #get the number of in headers
      def num_headers
        @inheaders.length
      end

      #add a parse header to the outgoing pool of headers
      def add_outheader(amf_header)
        @outheaders << amf_header
      end

      #get a header at a specific index
      def get_outheader_at(i=0)
        @outheaders[i]||false
      end

      #get all the in headers
      def get_outheaders
        @outheaders
      end

      #Get the number of out headers
      def num_outheaders
        @outheaders.length
      end

      #add a body
      def add_body(amf_body)
        @bodys << amf_body
      end

      #get a body obj at index
      def get_body_at(i=0)
        @bodys[i]||false
      end

      #get the number of bodies
      def num_body
        @bodys.length
      end

      #add a body to the body pool at index
      def add_body_at(index,body)
        @bodys.insert(index,body)
      end
  
      #add a body to the top of the array
      def add_body_top(body)
        @bodys.unshift(body)
      end

      #Remove a body from the body pool at index
      def remove_body_at(index)
        @bodys.delete_at(index)
      end
  
      #remove the AUTH header, (it is always at the top)
      def remove_auth_body
        @bodys.shift
      end
  
      #remove all bodies except the auth body
      def only_auth_fail_body!
        auth_body = nil
        @bodys.each do |b|
          if b.inspect.to_s.match(/Authentication Failed/) != 
            auth_body = b
          end
        end
        @bodys = [auth_body] if auth_body
      end
    end
  end
end