module RubyAMF
  module Filters
    class AMFSerializerFilter
      def run(amfobj) 
        should_use_flails? ? encode_amf_object(amfobj) : RubyAMF::IO::AMFSerializer.new(amfobj).run
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