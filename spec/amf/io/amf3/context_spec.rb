require 'spec/spec_helper'
require 'lib/flails/io/util/generic_context'
require 'lib/flails/io/amf3/context'

module AMF3ContextHelper
  def add_objects(context)
    context.add 1
    context.add 2
    context.add "three"
    context.add %w(some words)
    context.add({:a => "hash"})    
  end
  
  def expected_contents
    [1, 2, "three", ["some", "words"], {:a => "hash"}]
  end
end

describe Flails::IO::AMF3::Context do
  include AMF3ContextHelper

  before(:each) do
    @amf3_context = Flails::IO::AMF3::Context.new
  end

  describe "handling the object context" do
    before(:each) do
      @context = @amf3_context.objects
    end

    it_should_behave_like "amf context"
  end


  describe "handling the class context" do
    before(:each) do
      @context = @amf3_context.strings
    end

    it_should_behave_like "amf context"
  end

  describe "handling the string context" do
    before(:each) do
      @context = @amf3_context.classes
    end

    it_should_behave_like "amf context"
  end
  
end