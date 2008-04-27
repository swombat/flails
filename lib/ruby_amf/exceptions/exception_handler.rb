require 'app/request_store'
require 'app/amf'
module RubyAMF
  module Exceptions

    #This class is used to take an AMFException and translate it into something that is useful when returned back to flash.
    class ExceptionHandler
      include RubyAMF::App
  
      def ExceptionHandler.HandleException(e, body)
        if RequestStore.amf_encoding == 'amf3'
          body.results = RubyAMF::Exceptions::AS3Fault.new(e)
          #trigger RemoteObject failure for AsyncTokens
          if body.special_handling == "RemotingMessage"
            body.results["correlationId"] = body.get_meta('messageId')
            body.results["clientId"] = body.get_meta('clientId') || body.results["correlationId"]
          end
        else
          body.fail! #force the fail trigger for F8, this causes it to map to the onFault handler
          body.results = RubyAMF::Exceptions::ASFault.new(e)
        end
      end
    end
    
  end
end