require 'app/configuration'
module RubyAMF
  module App
    # Invoke ActionController's process on the target controller action
    class RailsInvokeAction
      include RubyAMF::App
      include RubyAMF::Exceptions
      include RubyAMF::Configuration
      include RubyAMF::Util::ActionUtils
      
      def run(amfbody)
        if amfbody.exec == false
          if amfbody.special_handling == 'Ping'
            amfbody.results = generate_acknowledge_object(amfbody.get_meta('messageId'), amfbody.get_meta('clientId')) #generate an empty acknowledge message here, no body needed for a ping
            amfbody.success! #flag the success response
          end
          return
        end
        @amfbody = amfbody #store amfbody in member var
        invoke
      end
      
      #invoke the service call
      def invoke
        begin 
          # RequestStore.available_services[@amfbody.service_class_name] ||=
          @service =  @amfbody.service_class_name.constantize.new #handle on service
        rescue Exception => e
          puts e.message
          puts e.backtrace
          raise RubyAMF::Exceptions::AMFException.new(RubyAMF::Exceptions::AMFException::UNDEFINED_OBJECT_REFERENCE_ERROR, "There was an error loading the service class #{@amfbody.service_class_name}")
        end
        
        if @service.private_methods.include?(@amfbody.service_method_name)
          raise RubyAMF::Exceptions::AMFException.new(RubyAMF::Exceptions::AMFException::METHOD_ACCESS_ERROR, "The method {#{@amfbody.service_method_name}} in class {#{@amfbody.service_class_file_path}} is declared as private, it must be defined as public to access it.")
        elsif !@service.public_methods.include?(@amfbody.service_method_name)
          raise RubyAMF::Exceptions::AMFException.new(RubyAMF::Exceptions::AMFException::METHOD_UNDEFINED_METHOD_ERROR, "The method {#{@amfbody.service_method_name}} in class {#{@amfbody.service_class_file_path}} is not declared.")
        end
        
        #clone the request and response and alter it for the target controller/method
        req = RequestStore.rails_request.clone
        res = RequestStore.rails_response.clone
        
        #change the request controller/action targets and tell the service to process. THIS IS THE VOODOO. SWEET!
        controller = @amfbody.service_class_name.gsub("Controller","").underscore
        action     = @amfbody.service_method_name
        req.parameters['controller'] = req.request_parameters['controller'] = req.path_parameters['controller'] = controller
        req.parameters['action']     = req.request_parameters['action']     = req.path_parameters['action']     = action
        req.env['PATH_INFO']         = req.env['REQUEST_PATH']              = req.env['REQUEST_URI']            = "#{controller}/#{action}"
        req.env['HTTP_ACCEPT'] = 'application/x-amf,' + req.env['HTTP_ACCEPT'].to_s
        
        #set conditional helper
        @service.is_amf = true
        @service.is_rubyamf = true
        
        #process the request
        rubyamf_params = @service.rubyamf_params = {}
        if @amfbody.value && !@amfbody.value.empty?
          @amfbody.value.each_with_index do |item,i|
            rubyamf_params[i] = item
          end
        end
        
        # put them by default into the parameter hash if they opt for it
        rubyamf_params.each{|k,v| req.parameters[k] = v} if ParameterMappings.always_add_to_params       
          
        begin
          #One last update of the parameters hash, this will map custom mappings to the hash, and will override any conflicting from above
          ParameterMappings.update_request_parameters(@amfbody.service_class_name, @amfbody.service_method_name, req.parameters, rubyamf_params, @amfbody.value)
        rescue Exception => e
          raise RubyAMF::Exceptions::AMFException.new(RubyAMF::Exceptions::AMFException::PARAMETER_MAPPING_ERROR, "There was an error with your parameter mappings: {#{e.message}}")
        end
        @service.process(req, res)
        
        #unset conditional helper
        @service.is_amf = false
        @service.is_rubyamf = false
        @service.rubyamf_params = rubyamf_params # add the rubyamf_args into the controller to be accessed
        
        result = RequestStore.render_amf_results
        
        #handle FaultObjects
        if RubyAMF::Exceptions::FaultObject === result
          raise RubyAMF::Exceptions::AMFException.new(result['code'], result['message'])
        end
        
        #amf3
        @amfbody.results = result
        if @amfbody.special_handling == 'RemotingMessage'
          @wrapper = generate_acknowledge_object(@amfbody.get_meta('messageId'), @amfbody.get_meta('clientId'))
          @wrapper["body"] = result
          @amfbody.results = @wrapper
        end
        @amfbody.success! #set the success response uri flag (/onResult)
      end
    end
  end
end