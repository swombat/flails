module RubyAMF
  module Filters
    class AMFSerializerFilter
      def run(amfobj) 
        RAILS_DEFAULT_LOGGER.debug "\n\n==================\n#{amfobj.inspect}\n================\n\n"

        should_use_flails? ? encode_amf_object(amfobj) : RubyAMF::IO::AMFSerializer.new(amfobj).run
        
        RAILS_DEFAULT_LOGGER.debug "\n\n>>>>>>>>>>>>>>>>>>>\n#{amfobj.output_stream.inspect}\n================\n\n"
      end
      
      def should_use_flails?
        RubyAMF::Configuration::ClassMappings.use_flails_serializer
      end
      
      def encode_amf_object(amf_object)
        Flails::IO::Filter::AMFSerializerFilter.new.serialize(amf_object)
      end
      
    end
  end
end