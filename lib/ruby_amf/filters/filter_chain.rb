require 'io/amf_deserializer'
require 'io/amf_serializer'

module RubyAMF
  module Filters
    
    class FilterChain
      def run(amfobj)
        RubyAMF::App::RequestStore.filters.each do |filter|
          filter.run(amfobj)
        end
      end
    end
  end
end