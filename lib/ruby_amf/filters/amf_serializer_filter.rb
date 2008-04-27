require 'io/amf_deserializer'
require 'io/amf_serializer'

module RubyAMF
  module Filters
    class AMFSerializerFilter
      include RubyAMF::IO
      def run(amfobj) 
        AMFSerializer.new(amfobj).run 
      end
    end
  end
end