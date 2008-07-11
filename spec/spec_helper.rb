# Unordered
require 'date'
require 'lib/flails/io/util/undefined_type'
require 'lib/flails/app/model/renderable'

# Ordered
require 'lib/flails/io/util/generic_context'
require 'lib/flails/io/util/big_endian_writer'

require 'lib/flails/io/amf0/types'
require 'lib/flails/io/amf0/context'
require 'lib/flails/io/amf0/encoder'

require 'lib/flails/io/amf3/types'
require 'lib/flails/io/amf3/context'
require 'lib/flails/io/amf3/encoder'

require 'spec/shared_context_spec'

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
  def initialize(attribs={'a'=>'b'}, class_name=nil)
    @attribs = attribs
    @class_name = class_name
  end
  
  attr_reader :class_name
  
  def renderable_attributes
    @attribs
  end
end
