module RubyAMF
  module App
    # Wraps an amfbody with methods and params for easter manipulation
    class AMFBody

      include RubyAMF::App

      attr_accessor :id             #the amfbody id
      attr_accessor :response_index #the response unique index that the player understands, knows which result / fault methods to call.
      attr_accessor :response_uri   #the complete response uri (EX: /12/onStatus)  
      attr_accessor :target_uri     #the target uri (service name)  
      attr_accessor :service_class_file_path   #the service file path
      attr_accessor :service_class_name        #the service name  
      attr_accessor :service_method_name       #the service method name
      attr_accessor :value          #the parameters to use in the service call 
      attr_accessor :results        #the results from a service call  
      attr_accessor :special_handling     #special handling
      attr_accessor :exec           #executeable body
      attr_accessor :_explicitType  #set the explicit type

      #create a new amfbody object
      def initialize(target = "", response_index = "", value = "")
        @id = response_index.clone.split('/').to_s
        @target_uri = target
        @response_index = response_index
        @response_uri = @response_index + '/onStatus' #default to status call
        @value = value
        @exec = true
        @_explicitType = ""
        @meta = {}
      end

      #append string data the the response uri
      def append_to_response_uri(str)
        @response_uri = @response_uri + str
      end

      #set some meta data for this amfbody
      def set_meta(key,val)
        @meta[key] = val
      end

      #get the meta data by key
      def get_meta(key)
        @meta[key]
      end

      #trigger an update to the response_uri to be a successfull response (/1/onResult)
      def success!
        @response_uri = "#{@response_index}/onResult"
      end

      #force the call to fail in the flash player
      def fail!
        @response_uri = "#{@response_index}/onStatus"
      end

      # allows a target_uri of "services.[bB]ooks", "services.[bB]ooksController to become service_class_name "Services::BooksController" and the class file path to be "services/books_controller.rb" 
      def set_service_uri_information!
        if @target_uri 
          uri_elements =  @target_uri.split(".") 
          @service_method_name ||= uri_elements.pop # this was already set, probably amf3, that means the target_uri doesn't include it
          if !uri_elements.empty?
            uri_elements.last << "Controller" unless uri_elements.last.include?("Controller")
            @service_class_name      = uri_elements.collect(&:to_title).join("::")
            @service_class_file_path = "#{RequestStore.service_path}/#{uri_elements[0..-2].collect{|x| x+'/'}}#{uri_elements.last.underscore}.rb"
          else
            raise RubyAMF::Exceptions::AMFException.new(RubyAMF::Exceptions::AMFException::SERVICE_TRANSLATION_ERROR, "The correct service information was not provided to complete the service call. The service and method name were not provided")
          end
        else
          if RequestStore.flex_messaging
            raise RubyAMF::Exceptions::AMFException.new(RubyAMF::Exceptions::AMFException::USER_ERROR, "There is no \"source\" property defined on your RemoteObject, please see RemoteObject documentation for more information.")
          else
            raise RubyAMF::Exceptions::AMFException.new(RubyAMF::Exceptions::AMFException::SERVICE_TRANSLATION_ERROR, "The correct service information was not provided to complete the service call. The service and method name were not provided")
          end
        end
      end

    end
  end
end