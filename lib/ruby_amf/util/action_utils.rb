require 'app/configuration'
module RubyAMF
  module Util
    module ActionUtils
      
      def generate_acknowledge_object(message_id = nil, client_id = nil)
        res = RubyAMF::Util::VoHash.new
        res._explicitType = "flex.messaging.messages.AcknowledgeMessage"
        res["messageId"] = rand_uuid
        res["clientId"] = client_id||rand_uuid
        res["destination"] = nil
        res["body"] = nil
        res["timeToLive"] = 0
        res["timestamp"] = (String(Time.new) + '00')
        res["headers"] = {}
        res["correlationId"] = message_id
        res
      end
      
      #going for speed with these UUID's not neccessarily unique in space and time continue - um, word
      def rand_uuid
        [8,4,4,4,12].map {|n| rand_hex_3(n)}.join('-').to_s
      end
      
      def rand_hex_3(l)
        "%0#{l}x" % rand(1 << l*4)
      end
    end
  end
end