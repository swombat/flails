module Flails
  module IO
    module Filter
      class AMFSerializerFilter
        def serialize(amf_object)
          encoder = Flails::IO::AMF0::Encoder.new(amf_object.output_stream)
        
          encoder.writer.write :short, 3  # AMF version number

          encoder.stream << encode_headers(amf_object.outheaders)
        
          encoder.stream << encode_bodies(amf_object.bodies)
        end
      
        def encode_headers(amf_headers)
          encoder = Flails::IO::AMF0::Encoder.new
        
          encoder.writer.write :short, amf_headers.length
        
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
          encoder.writer.write :short, amf_bodies.length
          
          amf_bodies.each do |body|
            RAILS_DEFAULT_LOGGER.debug "\n\n>BBB Encoding Body: \n#{body.inspect}\nBBB\n\n"
            
          
            encoder.encode body.response_uri, false
            encoder.encode "null", false
            encoder.writer.write :int, -1
          
            encoder.writer.write :char, Flails::IO::AMF0::Types::AMF3
            amf3_encoder = Flails::IO::AMF3::Encoder.new(encoder.stream) # Reset the context for each body, but keep the stream
            
            message = Flails::IO::Util::AcknowledgeMessage.new(body.results)
            
            RAILS_DEFAULT_LOGGER.debug "\n\n>MMM Encoding AcknowledgeMessage: \n#{message.inspect}\nMMM\n\n"
            
            amf3_encoder.encode Flails::IO::Util::AcknowledgeMessage.new(body.results)
          end
        
          encoder.stream
        end
        
      end
    end
  end
end