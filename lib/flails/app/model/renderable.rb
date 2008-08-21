module Flails
  module App
    module Model
      # This module must be included by classes which wish to be rendered through the Flails API.
      # Typically, the Renderable inclusion and mapping directives should be auto-generated
      # from a YAML file... to be included.
      module Renderable
        # Returns a hash of the attributes to be rendered
        def renderable_attributes
          {}
        end
        
        def depth(max_depth)
          Flails::App::Model::RenderableClone.new(self, max_depth)
        end
      end
    end
  end
end