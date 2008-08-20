module Flails
  module IO
    module Util
      class OptimisedObjectsContext

        def initialize
          @objects = {}
          @counter = 0
          initialize_sub_hashes
        end
        
        def initialize_sub_hashes
          Flails::IO::Util::ClassDefinition.class_name_mappings.each do |class_name, mapping|
            @objects[class_name] = {}
          end
          @objects[Array.to_s] = {}
          @objects[Hash.to_s] = {}
        end
        
        def increment_counter
          @counter += 1
        end
        
        def clear!
          @objects = {}
          @counter = 0
          initialize_sub_hashes
        end

        def objects
          @objects
        end
        
        def add_with_id(object)
          @objects[object.class.to_s]["#{object.id}"] = @counter
          @counter += 1
        end

        def get_reference_with_id(object)
          @objects[object.class.to_s]["#{object.id}"]
        end
        
        def has_reference_for_with_id?(object)
          @objects[object.class.to_s].has_key?("#{object.id}")
        end
        
        def add(object)
          @objects[object.class.to_s]["#{object.hash}"] = @counter
          @counter += 1
        end

        def get_reference(object)
          @objects[object.class.to_s]["#{object.hash}"]
        end
        
        def has_reference_for?(object)
          @objects[object.class.to_s].has_key?("#{object.hash}")
        end
      end
    end
  end
end

