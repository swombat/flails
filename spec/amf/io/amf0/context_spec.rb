require 'spec/spec_helper'
require 'lib/flails/io/util/generic_context'
require 'lib/flails/io/amf0/context'

describe Flails::IO::AMF0::Context do
  include ContextHelper

  before(:each) do
    @amf0_context = Flails::IO::AMF0::Context.new
    @context = @amf0_context
  end

  it_should_behave_like "amf context"
  
end