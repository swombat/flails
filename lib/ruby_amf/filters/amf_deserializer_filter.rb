module RubyAMF
  module Filters
    class AMFDeserializerFilter
      def run(amfobj)
        RubyAMF::IO::AMFDeserializer.new.rubyamf_read(amfobj)
      end
    end
  end
end