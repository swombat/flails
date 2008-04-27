require 'io/amf_deserializer'
require 'io/amf_serializer'

module RubyAMF
  module Filters
    class AMFDeserializerFilter
      include RubyAMF::IO  
      def run(amfobj)
        AMFDeserializer.new.rubyamf_read(amfobj)
      end
    end
  end
end