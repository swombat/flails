module Flails
  module IO
    module Util
      class GenericContext

        def initialize
          @objects = {}
          @counter = 0
        end
        
        def increment_counter
          @counter += 1
        end
        
        def counter
          @counter
        end
        
        def add(obj)
          if (obj.is_a?(Hash))
            @objects["Hash=>#{obj.inspect}"] = @counter
          else
            @objects[obj] = @counter
          end
          @counter += 1
        end

        def clear!
          @objects = {}
        end
        
        def get_reference(object)
          object.class
          if (object.is_a?(Hash))
            @objects["Hash=>#{object.inspect}"]
          else
            @objects[object]
          end
        end
        
        def has_reference_for?(object)
          if (object.is_a?(Hash))
            @objects.has_key?("Hash=>#{object.inspect}")
          else
            @objects.has_key?(object)
          end
        end

        def objects
          @objects
        end
      end
    end
  end
end

