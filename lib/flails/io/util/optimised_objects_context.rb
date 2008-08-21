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

        def add_sub_hashes_for(objects)
          objects.each { |object| self.add_sub_hash_for(object)}
        end
        
        def add_sub_hash_for(object)
          @objects[object.class.to_s] ||= {}
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
          @objects.inject({}) { |memo, (key, sub_hash)| memo.merge!(sub_hash) }
        end
        
        # Objects with id
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
        
        # Hashes (need separate since {:a => 'a'}.hash != {:a => 'a'}.hash)
        def add_hash(object)
          @objects["Hash"]["#{object.to_s}"] = @counter
          @counter += 1
        end

        def get_reference_hash(object)
          @objects["Hash"]["#{object.to_s}"]
        end
        
        def has_reference_for_hash?(object)
          @objects["Hash"].has_key?("#{object.to_s}")
        end
        
        # Other objects
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

