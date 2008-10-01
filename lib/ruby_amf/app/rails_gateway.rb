# require 'app/gateway'
require 'zlib'
module RubyAMF
  module App
    #Rails Gateway, extends regular gateway and changes the actions
    class RailsGateway
  
      def initialize
        RubyAMF::App::RequestStore.filters =  [
                                                RubyAMF::Filters::AMFDeserializerFilter.new, 
                                                RubyAMF::Filters::AuthenticationFilter.new, 
                                                RubyAMF::Filters::BatchFilter.new, 
                                                RubyAMF::Filters::AMFSerializerFilter.new
                                              ]
        RubyAMF::App::RequestStore.actions =  [
                                                RubyAMF::App::PrepareAction.new, 
                                                RubyAMF::App::RailsInvokeAction.new
                                              ]
      end

      # All get and post requests circulate throught his method
      def service(raw)
        amfobj = RubyAMF::App::AMFObject.new(raw)
        RubyAMF::Filters::FilterChain.new.run(amfobj)
        RAILS_DEFAULT_LOGGER.info "Uncompressed size: #{amfobj.output_stream.length}"
        if RubyAMF::App::RequestStore.gzip
          stream = Zlib::Deflate.deflate(amfobj.output_stream)
          RAILS_DEFAULT_LOGGER.info "Compressed size: #{stream.length}"
          return stream
        else
          return amfobj.output_stream
        end
      end
    end
  end
end