require 'lib/flails/io/util/generic_context'
require 'lib/flails/io/amf0/context'

module AMF0ContextHelper
  def add_objects(context)
    context.add_object 1
    context.add_object 2
    context.add_object "three"
    context.add_object %w(some words)
    context.add_object({:a => "hash"})    
  end
  
  def expected_contents
    [1, 2, "three", ["some", "words"], {:a => "hash"}]
  end
end

describe Flails::IO::AMF0::Context do
  include AMF0ContextHelper

  before(:each) do
    @context = Flails::IO::AMF0::Context.new
  end

  describe "new context" do    
    it "should be empty" do
      @context.objects.length.should == 0
    end
  end

  describe "adding objects" do
    it "should support adding objects one at a time" do
      add_objects(@context)
      @context.objects.should == expected_contents
    end
  end

  describe "object with existing contents" do
    before(:each) do
      add_objects(@context)
    end

    describe "clone method" do
      it "should clone the object context" do
        @cloned = @context.clone
        @cloned.objects.should == expected_contents
      end
    end
    
    describe "clear method" do
      it "should clear out all contents" do
        @context.clear!
        @context.objects.should == []
      end
    end
    
    it "should be able to retrieve by reference" do
      expected_contents.each_index do |index|
        @context.get_by_reference(index).should == expected_contents[index]
      end
    end

    it "should be able to retrieve the reference" do
      expected_contents.each_index do |index|
        @context.get_reference(expected_contents[index]).should == index
      end
    end
    
    describe "has_reference method" do
      it "should return true when the context contains the test objects" do
        expected_contents.each do |value|
          @context.has_reference_for?(value).should == true
        end
      end
      
      it "should not return true for other values" do
        @context.has_reference_for?("asdf").should == false
      end
    end
  end
  
end