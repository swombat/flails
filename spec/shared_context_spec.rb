module ContextHelper
  attr_accessor :include_hash
  
  def add_objects(context)
    context.add 1
    context.add 2
    context.add "three"
    context.add %w(some words)
    context.add({:a => "hash"}) if @include_hash != false
  end
  
  def expected_contents
    @include_hash == false ? [1, 2, "three", ["some", "words"]] : [1, 2, "three", ["some", "words"], {:a => "hash"}]
  end
end


shared_examples_for "amf context" do
  include ContextHelper
  
  describe "new context" do    
    it "should be empty" do
      @context.objects.length.should == 0
    end
  end

  describe "adding objects" do
    it "should support adding objects one at a time" do
      add_objects(@context)
      @context.objects.length.should == expected_contents.length
    end
  end

  describe "object with existing contents" do
    before(:each) do
      add_objects(@context)
    end

    describe "clear method" do
      it "should clear out all contents" do
        @context.clear!
        @context.objects.should be_empty
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