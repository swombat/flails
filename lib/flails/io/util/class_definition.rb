module Flails
  module IO
    module Util
      class ClassDefinition
        
        #======================
        # Instantiation / Retrieval
        def self.clear!
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
        
        def self.class_name_mappings
          @@class_name_mappings ||= {}
          @@class_name_mappings
        end

        def self.mappings
          @@mappings ||= {}
          @@mappings
        end
        
        #======================
        # Instance Methods
        
        # The Flex-side class name to be used when rendering
        def flex_class_name
          @flex_class_name
        end
        
        # The attributes to be rendered
        def attributes
          @attributes
        end
        
        def sealed_attributes_count
          encoding == Flails::IO::AMF3::Types::OBJECT_DYNAMIC ? 0 : @attributes.length
        end
        
        def encoding
          @flex_class_name.blank? ? Flails::IO::AMF3::Types::OBJECT_DYNAMIC : Flails::IO::AMF3::Types::OBJECT_STATIC
        end
        
      private
        def initialize(object)
          @flex_class_name          = @@class_name_mappings[object.class.to_s]
          @attributes               = Hash === object.renderable_attributes ? object.renderable_attributes.keys : object.renderable_attributes
          @@mappings[object.class]  = self
        end
        
      end
    end
  end
end