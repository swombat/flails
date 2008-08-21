module Flails
  module App
    module Model
      class RenderableClone
        include Flails::App::Model::Renderable
        attr_reader :original
        
        def class
          @original.class
        end
        
        def initialize(original, max_depth)
          @original = original
          @max_depth = max_depth
          self.clone_attributes
        end
        
        def clone_attributes
          @renderable_attributes = {}
          @original.renderable_attributes.each do |key, value|
            RAILS_DEFAULT_LOGGER.debug "=== #{key.inspect} = > #{value.inspect} =? #{value.is_a?(Enumerable)}\n\n"
            
            @renderable_attributes[key] = render_value(value)
            
            RAILS_DEFAULT_LOGGER.debug "....... set to #{@renderable_attributes[key].inspect}"
          end
        end
        
        def render_value(value)
          if value.is_a?(Hash) || value.is_a?(Array)
            value.depth(@max_depth-1)
          elsif value.respond_to?(:depth)
            if (@max_depth < 0)
              nil
            else
              value.depth(@max_depth-1)
            end
          else
            value
          end
        end
                
        def renderable_attributes
          @renderable_attributes
        end

        def method_missing(id, *args)
          @original.send(id, *args)
        end
      end
    end
  end
end