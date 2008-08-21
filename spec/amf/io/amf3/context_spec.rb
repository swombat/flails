require 'spec/spec_helper'
require 'lib/flails/io/util/generic_context'
require 'lib/flails/io/amf3/context'

describe Flails::IO::AMF3::Context do
  include ContextHelper

  before(:each) do
    @amf3_context = Flails::IO::AMF3::Context.new
    @amf3_context.objects.add_sub_hashes_for(self.expected_contents)
  end

  describe "handling the object context" do
    before(:each) do
      @context = @amf3_context.objects
      @include_hash = false
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
  
  describe "clearing all contexts at the same time" do
    before(:each) do
      add_objects(@amf3_context.objects)
      add_objects(@amf3_context.strings)
      add_objects(@amf3_context.classes)
      @amf3_context.clear!
    end

    it "should be empty" do
      @amf3_context.objects.objects.should be_empty
      @amf3_context.strings.objects.should be_empty
      @amf3_context.classes.objects.should be_empty
    end
  end

end