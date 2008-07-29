require 'spec/spec_helper'

module ClassDefinitionSpecHelper
end

describe Flails::IO::Util::ClassDefinition do
  include ClassDefinitionSpecHelper

  describe "untyped renderable class definition" do
    before(:each) do
      Flails::IO::Util::ClassDefinition::clear!
      @untyped_object       = RenderableObject.new()
      @untyped_definition   = Flails::IO::Util::ClassDefinition::get(@untyped_object)
    end
    
    it "should have an empty class_name" do
      @untyped_definition.flex_class_name.should == nil
    end
    
    it "should have one renderable attribute" do
      @untyped_definition.attributes.length.should == 1
    end
    
    it "should be encoded as a Proxy object" do
      @untyped_definition.encoding.should == Flails::IO::AMF3::Types::OBJECT_DYNAMIC
    end
  end

  describe "typed renderable class definition" do
    before(:each) do
      Flails::IO::Util::ClassDefinition::clear!
      Flails::IO::Util::ClassDefinition::class_name_mappings = { RenderableObject.to_s => "org.flails.spam" }
      @typed_object         = RenderableObject.new({'baz' => 'hello'})
      @typed_definition     = Flails::IO::Util::ClassDefinition::get(@typed_object)
    end

    it "should have the correct class name" do
      @typed_definition.flex_class_name.should == "org.flails.spam"
    end
    
    it "should have one attribute" do
      @typed_definition.attributes.length.should == 1
    end

    it "should be encoded as a Static object" do
      @typed_definition.encoding.should == Flails::IO::AMF3::Types::OBJECT_STATIC
    end
  end
  
  describe "retrieving the same object type several times" do
    before(:each) do
      Flails::IO::Util::ClassDefinition::clear!
      Flails::IO::Util::ClassDefinition::class_name_mappings = { RenderableObject.to_s => "obj.class" }
      @object1            = RenderableObject.new({:foo => "bar"})
      @object2            = RenderableObject.new({:foo => "baz"})
      @class_definition1  = Flails::IO::Util::ClassDefinition::get(@object1)
      @class_definition2  = Flails::IO::Util::ClassDefinition::get(@object2)
    end
    
    it "should have the same class definition for both objects" do
      @class_definition1.should == @class_definition2
    end
    
    it "should pick up the class_name from the first object" do
      @class_definition2.flex_class_name.should == "obj.class"
    end    
  end
  
end