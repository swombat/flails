module Flails
  module IO
    module Util
      class ClassDefinition
        
        def self.reset!
          @@mappings = {}
          @@class_name_mappings = {}
        end
        
        def self.get(klass)
          @@mappings ||= {}
          @@mappings[klass.class] || ClassDefinition.new(klass)
        end
        
        def self.class_name_mappings=(class_name_mappings={})
          @@class_name_mappings ||= {}
          @@class_name_mappings.merge!(class_name_mappings)
        end
        
        # The Flex-side class name to be used when rendering
        def flex_class_name
          @flex_class_name
        end
        
        # The attributes to be rendered
        def attributes
          @attributes
        end
        
      private
        def initialize(klass)
          @flex_class_name        = @@class_name_mappings[klass.class.to_s]
          @attributes             = klass.renderable_attributes
          @@mappings[klass.class] = self
        end
        
      end
    end
  end
end