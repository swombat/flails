module RubyAMF
  module Exceptions

    #Encompasses all AMF specific exceptions that occur
    class AMFException < Exception
  
      #when version is not 0 or 3
      VERSION_ERROR                         = 'AMF_AMF_VERSION_ERROR'
      #when translating the target_uri of a body, there isn't a .(period) to map the service / method name
      SERVICE_TRANSLATION_ERROR             = 'AMF_SERVICE_TRANSLATION_ERROR'
      #when an authentication error occurs
      AUTHENTICATION_ERROR                  = 'AMF_ATUHENTICATION_ERROR'
      #when a method is called, but the method is either private or doesn't exist
      METHOD_ACCESS_ERROR                   = 'AMF_METHOD_ACCESS_ERROR'
      #when a mehod is undefined
      METHOD_UNDEFINED_METHOD_ERROR         = 'AMF_UNDECLARED_METHOD_ERROR'
      #when there is an error with session implementation
      SESSION_ERROR                         = 'AMF_SESSION_ERROR'
      #when a general user error has occured
      USER_ERROR                            = 'AMF_USER_ERROR'
      #when parsing AMF3, an undefined object reference
      UNDEFINED_OBJECT_REFERENCE_ERROR      = 'AMF_UNDEFINED_OBJECT_REFERENCE_ERROR'
      #when parsing AMF3, an undefined class definition
      UNDEFINED_DEFINITION_REFERENCE_ERROR  = 'AMF_UNDEFINED_DEFINIITON_REFERENCE_ERROR'
      #when parsing amf3, an undefined string reference
      UNDEFINED_STRING_REFERENCE_ERROR      = 'AMF_UNDEFINED_STRING_REFERENCE_ERROR'
      #unsupported AMF0 type
      UNSUPPORTED_AMF0_TYPE                 = 'UNSUPPORTED_AMF0_TYPE'
      #when the Rails ActionController Filter chain haults
      FILTER_CHAIN_HAULTED                  = 'RAILS_ACTION_CONTROLLER_FILTER_CHAIN_HAULTED'
      #when active record errors
      ACTIVE_RECORD_ERRORS                  = 'ACTIVE_RECORD_ERRORS'
      #whan amf data is incomplete or incorrect
      AMF_ERROR                             = 'AMF_ERROR'
      #vo errors
      VO_ERROR                              = 'VO_ERROR'
      #when a parameter mapping error occurs
      PARAMETER_MAPPING_ERROR               = "PARAMETER_MAPPING_ERROR"
  
      attr_accessor :message
      attr_accessor :etype
      attr_accessor :ebacktrace
  
      def initialize(type,msg)
        super(msg)
        @message = msg
        @etype = type
      end
  
      # stringify the message
      def to_s
        @msg
      end
  
    end
  end
end
