require 'spec/spec_helper'

module ClassDefinitionSpecHelper
end

describe Flails::IO::Util::ClassDefinition do
  include ClassDefinitionSpecHelper

  describe "untyped renderable class definition" do
    before(:each) do
      Flails::IO::Util::ClassDefinition::reset!
      @untyped_object       = RenderableObject.new()
      @untyped_definition   = Flails::IO::Util::ClassDefinition::get(@untyped_object)
    end
    
    it "should have an empty class_name" do
      @untyped_definition.class_name.should == nil
    end
    
    it "should have one renderable attribute" do
      @untyped_definition.attributes.length.should == 1
    end    
  end

  describe "typed renderable class definition" do
    before(:each) do
      Flails::IO::Util::ClassDefinition::reset!
      @typed_object         = RenderableObject.new({'baz' => 'hello'}, "org.flails.spam")
      @typed_definition     = Flails::IO::Util::ClassDefinition::get(@typed_object)
    end

    it "should have the correct class name" do
      @typed_definition.class_name.should == "org.flails.spam"
    end
    
    it "should have one attribute" do
      @typed_definition.attributes.length.should == 1
    end
  end
  
  describe "retrieving the same object type several times" do
    before(:each) do
      Flails::IO::Util::ClassDefinition::reset!
      @object1            = RenderableObject.new({:foo => "bar"}, "obj.class")
      @object2            = RenderableObject.new({:foo => "baz"})
      @class_definition1  = Flails::IO::Util::ClassDefinition::get(@object1)
      @class_definition2  = Flails::IO::Util::ClassDefinition::get(@object2)
    end
    
    it "should have the same class definition for both objects" do
      @class_definition1.should == @class_definition2
    end
    
    it "should pick up the class_name from the first object" do
      @class_definition2.class_name.should == "obj.class"
    end    
  end
  
end