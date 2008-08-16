module Flails
  module IO
    module AMF
      module FlexTypes
        class ErrorMessage
          include Flails::App::Model::Renderable

          def initialize(wrapped_hash)
            @wrapped_hash = wrapped_hash
          end

          def renderable_attributes
            @wrapped_hash
          end

          def method_missing(id, *args)
            @wrapped_hash.send(id, args)
          end
        end
      end
    end
  end
end