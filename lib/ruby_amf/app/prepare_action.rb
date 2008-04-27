module RubyAMF
  module App
    #This sets up each body for processing
    class PrepareAction
      include RubyAMF::App
      include RubyAMF::Util::ActionUtils
      
      def run(amfbody)
        if RequestStore.amf_encoding == 'amf3'  && #AMF3
          (raw_body = amfbody.value[0]).is_a?(RubyAMF::Util::VoHash) &&
            ['flex.messaging.messages.RemotingMessage','flex.messaging.messages.CommandMessage'].include?(raw_body._explicitType)
          case raw_body._explicitType
          when 'flex.messaging.messages.RemotingMessage' #Flex Messaging setup
            RequestStore.flex_messaging = true # only set RequestStore and ClassMappings when its a remoting message, not command message
            RubyAMF::Configuration::ClassMappings.use_array_collection = !(RubyAMF::Configuration::ClassMappings.use_array_collection==false) # it will only set it to false if the user specifically sets use_array_collection to false
            amfbody.special_handling = 'RemotingMessage'
            amfbody.value = raw_body['body']
            amfbody.set_meta('clientId', raw_body['clientId'])
            amfbody.set_meta('messageId', raw_body['messageId'])
            amfbody.target_uri = raw_body['source']
            amfbody.service_method_name = raw_body['operation']
            amfbody._explicitType = raw_body._explicitType
          when 'flex.messaging.messages.CommandMessage' #it's a ping, don't process this body, and hence, dont set service uri information
            if raw_body['operation'] == 5
              amfbody.exec = false
              amfbody.special_handling = 'Ping'
              amfbody.set_meta('clientId', raw_body['clientId'])
              amfbody.set_meta('messageId', raw_body['messageId'])
            end
            return # we don't want it to run set_service_uri_information
          end
        else
          RequestStore.flex_messaging = false # ensure that array_collection is disabled 
          RubyAMF::Configuration::ClassMappings.use_array_collection = false
        end
        
        amfbody.set_service_uri_information!
      end  
    end
  end
end