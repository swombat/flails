# Unordered
require 'date'
require 'lib/flails/io/util/undefined_type'
require 'lib/flails/app/model/renderable'
require 'lib/flails/io/invalid_input_exception'

# Ordered
require 'lib/flails/io/util/generic_context'
require 'lib/flails/io/util/big_endian_writer'
require 'lib/flails/io/util/class_definition'

require 'lib/flails/io/amf0/types'
require 'lib/flails/io/amf0/context'
require 'lib/flails/io/amf0/encoder'

require 'lib/flails/io/amf3/types'
require 'lib/flails/io/amf3/context'
require 'lib/flails/io/amf3/encoder'

require 'lib/flails/io/util/acknowledge_message'
require 'lib/flails/io/util/reference_wrapper'

require 'spec/shared_context_spec'

class FakeLogger
  def debug(*args)
    
  end
end

RAILS_DEFAULT_LOGGER = FakeLogger.new

module AMFEncoderHelper
  def test_run(encoder, data)
    data.each do |key, value|
      stream = ""
      encoder.stream = stream
      encoder.encode key
      stream.should == value
    end
  end
end

class RenderableObject
  include Flails::App::Model::Renderable
  def initialize(attribs={'a'=>'b'})
    @attribs = attribs
  end
  
  def renderable_attributes
    @attribs
  end
end

class RenderableObject1 < RenderableObject
end
class RenderableObject2 < RenderableObject
end
class RenderableObject3 < RenderableObject
end

Flails::IO::Util::ClassDefinition.class_name_mappings = { 
  Flails::IO::Util::AcknowledgeMessage.to_s => "flex.messaging.messages.AcknowledgeMessage",
  Flails::IO::AMF::FlexTypes::ErrorMessage.to_s => "flex.messaging.messages.ErrorMessage"
}