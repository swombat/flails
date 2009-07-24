module Flails
  module App
    module Model
      class RenderableClone
        include Flails::App::Model::Renderable
        attr_reader :original
        
        def id
          @original.id
        end
        
        def class
          @original.class
        end
        
        def is_a?(klass)
          @original.is_a?(klass)          
        end
        
        def initialize(original, max_depth, options={})
          @original = original
          @max_depth = max_depth
          @options = options
          self.clone_attributes
        end
        
        def clone_attributes
          @renderable_attributes = {}
          attributes = @max_depth > 0 ? @original.renderable_attributes : @original.renderable_attributes_without_depth
          attributes.each do |key, value|
            @renderable_attributes[key] = render_value(value, @options[:truncate].andand.include?(key))
          end
        end
        
        def render_value(value, truncate=false)
          if value.is_a?(Hash) || value.is_a?(Array)
            value.depth(truncate ? 0 : @max_depth-1, @options)
          elsif value.respond_to?(:depth)
            @max_depth < 0 ? nil : value.depth(truncate ? 0 : @max_depth-1, @options)
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