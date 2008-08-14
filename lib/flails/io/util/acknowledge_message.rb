module Flails
  module IO
    module Util
      class AcknowledgeMessage
        include Flails::App::Model::Renderable
        
        def initialize(results_hash)
          @results_hash = results_hash
        end
        
        def renderable_attributes
          @results_hash
        end
        
        def method_missing(id, *args)
          @results_hash.send(id, args)
        end        
      end
    end
  end
end
