module Flails
  module IO
    module Util
      class GenericContext

        attr_reader :objects
        
        def initialize
          @objects = []
        end
        
        def add_object(obj)
          @objects << obj
        end

        def clear!
          @objects = []
        end
        
        def get_by_reference(reference)
          @objects[reference]
        end
        
        def get_reference(object)
          @objects.index(object)
        end
        
        def has_reference_for?(object)
          self.get_reference(object) != nil
        end

      end
    end
  end
end

