module Flails
  module IO
    module Util
      class ClassDefinition
        
        def self.reset!
          @@mappings = {}
        end
        
        def self.get(klass)
          @@mappings ||= {}
          @@mappings[klass.class] || ClassDefinition.new(klass)
        end
        
        # The Flex-side class name to be used when rendering
        def class_name
          @class_name
        end
        
        # The attributes to be rendered
        def attributes
          @attributes
        end
        
      private
        def initialize(klass)
          @class_name = klass.class_name
          @attributes = klass.renderable_attributes
          @@mappings[klass.class] = self
        end
        
      end
    end
  end
end