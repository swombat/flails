require 'rubygems'
require 'activesupport'

require 'date'

$LOAD_PATH << File.dirname(__FILE__) + "/../lib/"

Dependencies.load_paths = $LOAD_PATH

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
  
  attr_reader :id
  
  def initialize(attribs={'a'=>'b'})
    @attribs = attribs
    @id = rand(1000)
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