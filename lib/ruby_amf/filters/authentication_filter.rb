require 'io/amf_deserializer'
require 'io/amf_serializer'

module RubyAMF
  module Filters

    class AuthenticationFilter
      include RubyAMF::App
      def run(amfobj)
        RequestStore.auth_header = nil # Aryk: why do we need to rescue this? 
        if (auth_header = amfobj.get_header_by_key('Credentials'))
          RequestStore.auth_header = auth_header #store the auth header for later
          RequestStore.rails_authentication = {:username => auth_header.value['userid'], :password => auth_header.value['password']}
        end
      end
    end
  end
end