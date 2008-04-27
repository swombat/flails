#This stores supporting configuration classes used in the config file to register class mappings and parameter mappings etc.
module RubyAMF
  module Configuration
    class ParameterMappings
      @parameter_mappings = {}
      @always_add_to_params = true
      @scaffolding = false
      
      class << self
        
        attr_accessor :scaffolding, :always_add_to_params
        
        def register(mapping)
          raise RubyAMF::Exceptions::AMFException.new(RubyAMF::Exceptions::AMFException::USER_ERROR, "You must atleast specify the :controller for a parameter mapping") unless mapping[:controller]
          set_parameter_mapping(mapping[:controller], mapping[:action], mapping)
        end
        
        def update_request_parameters(controller_class_name, controller_action_name, request_params,  rubyamf_params, remoting_params)
          if map = get_parameter_mapping(controller_class_name, controller_action_name)
            map[:params].each do |k,v|
              val = eval("remoting_params#{v}")
              if scaffolding && val.is_a?(ActiveRecord::Base)
                request_params[k.to_sym] = val.attributes.dup
                val.instance_variables.each do |assoc|
                  next if "@new_record" == assoc
                  request_params[k.to_sym][assoc[1..-1]] = val.instance_variable_get(assoc)
                end
              else
                request_params[k.to_sym] = val
              end
              rubyamf_params[k.to_sym]  = request_params[k.to_sym] # assign it to rubyamf_params for consistency
            end
          else #do some default mappings for the first element in the parameters
            if remoting_params.is_a?(Array)
              if scaffolding
                if (first = remoting_params[0])
                  if first.is_a?(ActiveRecord::Base)
                    key = first.class.to_s.downcase.to_sym
                    rubyamf_params[key] = first.attributes.dup
                    first.instance_variables.each do |assoc|
                      next if "@new_record" == assoc
                      rubyamf_params[key][assoc[1..-1]] = first.instance_variable_get(assoc)
                    end
                    if always_add_to_params #if wanted in params, put it in
                      request_params[key] = rubyamf_params[key] #put it into rubyamf_params
                    end
                  else
                    if first.is_a?(RubyAMF::Util::VoHash)
                      if (key = first.explicitType.split('::').last.downcase.to_sym)
                        rubyamf_params[key] = first
                        if always_add_to_params
                          request_params[key] = first
                        end
                      end
                      request_params[:id] = rubyamf_params[:id] = first['id'] if first['id'] && !first['id']==0
                    end
                  end
                end
              end
            end
          end
        end
        
        private
        def get_parameter_mapping(controller_class_name, controller_action_name) 
          @parameter_mappings[end_point_string(controller_class_name, controller_action_name)]|| # first check to see if there is a paramter mapping for the controller/action combo, 
          @parameter_mappings[end_point_string(controller_class_name)] # then just check if there is one for the controller
        end
        
        def set_parameter_mapping(controller_class_name, controller_action_name, mapping)
          @parameter_mappings[end_point_string(controller_class_name, controller_action_name)] = mapping
        end
        
        def end_point_string(controller_class_name, controller_action_name=nil) # if the controller_action_name is nil, than we the parameter mapping is for the entire controller
          eps = controller_class_name.to_s.dup # could be a symbol from the class mapping ; need to dup because it will recursively append the action_name
          eps << ".#{controller_action_name}" if controller_action_name
          eps
        end
        
      end 
    end
  end
end
