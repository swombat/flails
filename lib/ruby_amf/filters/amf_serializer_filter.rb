module RubyAMF
  module Filters
    class AMFSerializerFilter
      def run(amfobj) 
        RAILS_DEFAULT_LOGGER.debug "\n\n==================\n#{amfobj.inspect}\n================\n\n"

        RubyAMF::Configuration::ClassMappings.use_flails_serializer ? encode_amf_object(amfobj) : RubyAMF::IO::AMFSerializer.new(amfobj).run
        
        RAILS_DEFAULT_LOGGER.debug "\n\n>>>>>>>>>>>>>>>>>>>\n#{amfobj.output_stream.inspect}\n================\n\n"
      end
      
      def encode_amf_object(amf_object)
        encoder = Flails::IO::AMF0::Encoder.new(amf_object.output_stream)
        
        encoder.encode 3, false # AMF3

        encoder.stream << encode_headers(amf_object.outheaders)
        
        encoder.stream << encode_bodies(amf_object.bodies)
      end
      
      def encode_headers(amf_headers)
        encoder = Flails::IO::AMF0::Encoder.new
        
        encoder.encode amf_headers.length, false
        
        amf_headers.each do |header|
          RAILS_DEFAULT_LOGGER.debug "\n\n>HHH Encoding Header: \n#{header.inspect}\nHHH\n\n"
          
          encoder.encode header.name, false
          encoder.encode header.required, false
          encoder.encode -1, false
          
          encoder.encode @header.value
        end
        
        encoder.stream
      end
      
      def encode_bodies(amf_bodies)
        encoder = Flails::IO::AMF0::Encoder.new
        encoder.encode amf_bodies.length
        
        amf_bodies.each do |body|
          RAILS_DEFAULT_LOGGER.debug "\n\n>BBB Encoding Body: \n#{body.inspect}\nBBB\n\n"
          
          
          encoder.encode body.response_uri
          encoder.encode "null"
          encoder.encode -1, false
          
          encoder.encode Flails::IO::AMF0::Types::AMF3
          amf3_encoder = Flails::IO::AMF3::Encoder.new(encoder.stream) # Reset the context for each body, but keep the stream
          amf3_encoder.encode body.results
        end
        
        encoder.stream
      end
      
    end
  end
end