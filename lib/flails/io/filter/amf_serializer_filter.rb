module Flails
  module IO
    module Filter
      class AMFSerializerFilter
        def array_collection_type
          RubyAMF::Configuration::ClassMappings.use_array_collection == true ? "flex.messaging.io.ArrayCollection" : RubyAMF::Configuration::ClassMappings.use_array_collection
        end
        
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
            encoder.encode body.response_uri, false
            encoder.encode "null", false
            encoder.writer.write :int, -1
          
            encoder.writer.write :char, Flails::IO::AMF0::Types::AMF3
            amf3_encoder = Flails::IO::AMF3::Encoder.new(encoder.stream) # Reset the context for each body, but keep the stream
            amf3_encoder.array_collection_type = array_collection_type
            
            amf3_encoder.encode Flails::IO::Util::AcknowledgeMessage.new(body.results)
          end
        
          encoder.stream
        end
        
      end
    end
  end
end