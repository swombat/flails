require 'lib/util/string'

describe String do
    
  describe "to_snake!" do
    it "should correctly snakeize a test string" do
      "nofirstCapString".to_snake!.should == "nofirst_cap_string"
    end
    
    it "should keep the first capital letter if present" do
      "CapString".to_snake!.should == "Cap_string"
    end
    
    it "should not do anything to a string with no caps" do
      "nocapstring".to_snake!.should == "nocapstring"
    end
    
    it "should not do anything to an already snakeized string" do
      "snake_test_string".to_snake!.should == "snake_test_string"
    end
  end
  
  describe "to_camel!" do
    it "should correctly camelize a test string" do
      "a_string_with_underscore".to_camel!.should == "aStringWithUnderscore"
    end

    it "should keep the first capital letter if present" do
      "A_string_with_underscore".to_camel!.should == "AStringWithUnderscore"
    end

    it "should not do anything to a string with no caps" do
      "nocapstring".to_camel!.should == "nocapstring"
    end
    
    it "should not do anything to an already camelized string" do
      "camelTestString".to_camel!.should == "camelTestString"
    end
  end

  describe "to_title" do
    it "should correctly titlecase test strings" do
      "a string without title".to_title.should == "A string without title"
      "aStringWithoutTitle".to_title.should == "AStringWithoutTitle"
    end
    
    it "should not do anything to an already titled string" do
      "ATitledString".to_title.should == "ATitledString"
    end
  end
  
end