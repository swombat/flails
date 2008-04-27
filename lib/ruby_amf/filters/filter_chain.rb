require 'io/amf_deserializer'
require 'io/amf_serializer'

module RubyAMF
  module Filters
    
    class FilterChain
      def run(amfobj)
        RubyAMF::App::RequestStore.filters.each do |filter| #grab the filters to run through
          filter.run(amfobj)
          # puts "#{filter}: " +Benchmark.realtime{}.to_s
        end
      end
    end
  end
end