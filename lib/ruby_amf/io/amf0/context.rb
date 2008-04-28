module RubyAMF
  module IO
    module AMF0
      class Context

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

      end
    end
  end
end
