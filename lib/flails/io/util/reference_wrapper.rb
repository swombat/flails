module Flails
  module IO
    module Util
      # Wraps a referenceable item to ensure that it results in a new reference being created
      # Can also use this to mark an item as not needing to be indexed, and thus save access time
      # in the references table.
      class ReferenceWrapper
        def initialize(*args)
          
        end
      end
    end
  end
end