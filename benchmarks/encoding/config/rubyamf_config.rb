module RubyAMF
  module Configuration
    ClassMappings.use_flails_serializer = true
    ClassMappings.force_active_record_ids = true
    ClassMappings.assume_types = true
    ClassMappings.use_ruby_date_time = false
    ClassMappings.use_array_collection = true
    ClassMappings.check_for_associations = false
    ParameterMappings.always_add_to_params = false
    ParameterMappings.scaffolding = true
  end
end
