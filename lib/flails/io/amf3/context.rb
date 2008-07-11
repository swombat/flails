module Flails
  module IO
    module AMF3
      class Context
        attr_reader :objects, :strings, :classes
        
        def initialize
          @objects = Flails::IO::Util::GenericContext.new
          @strings = Flails::IO::Util::GenericContext.new
          @classes = Flails::IO::Util::GenericContext.new
        end
      end
    end
  end
end