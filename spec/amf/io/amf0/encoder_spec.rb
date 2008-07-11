require 'date'
require 'spec/spec_helper'

describe Flails::IO::AMF0::Encoder do
  include AMFEncoderHelper
  
  before(:each) do
    @encoder = Flails::IO::AMF0::Encoder.new    
  end
  
  
  describe "encoding primitives" do
    it "should successfully encode numbers" do
      data = {
        0           => "\x00\x00\x00\x00\x00\x00\x00\x00\x00",
        0.2         => "\x00\x3f\xc9\x99\x99\x99\x99\x99\x9a",
        1           => "\x00\x3f\xf0\x00\x00\x00\x00\x00\x00",
        42          => "\x00\x40\x45\x00\x00\x00\x00\x00\x00",
        -123        => "\x00\xc0\x5e\xc0\x00\x00\x00\x00\x00",
        1.23456789  => "\x00\x3f\xf3\xc0\xca\x42\x83\xde\x1b"
      }
      
      test_run(@encoder, data)
    end

    it "should successfully encode booleans" do
      data = {
        true        => "\x01\x01",
        false       => "\x01\x00"
      }
      
      test_run(@encoder, data)
    end
  end
  
    
  describe "encoding strings" do
    it "should successfully encode short strings" do
      data = {
        ""          => "\x02\x00\x00",
        "hello"     => "\x02\x00\x05hello",
        "Καλημέρα"  => "\x02\x00\x10\xce\x9a\xce\xb1\xce\xbb\xce\xb7\xce\xbc\xce\xad\xcf\x81\xce\xb1"
      }
      
      test_run(@encoder, data)
    end
    
    it "should successfully encode long strings" do
      data = {
        "12"*40000  => "\x0c\x00\x01\x38\x80#{'12'*40000}"
      }
      
      test_run(@encoder, data)      
    end
  end
  
  
  describe "encoding special values" do
    it "should successfully encode nulls" do
      data = {
        nil         => "\x05"
      }
      
      test_run(@encoder, data)
    end

    it "should successfully encode undefined values" do
      data = {
        Flails::IO::Util::UndefinedType.new  => "\x06"
      }
      
      test_run(@encoder, data)
    end
  end
  
  
  describe "encoding objects" do
    it "should successfully encode a hash" do
      data = {
        {'a' => 'a'}        => "\x03\x00\x01\x61\x02\x00\x01\x61\x00\x00\x09",
        {'a' => 'b'}        => "\x03\x00\x01\x61\x02\x00\x01\x62\x00\x00\x09"
      }
      
      test_run(@encoder, data)
    end
    
    it "should successfully encode an untyped Renderable object" do
      data ={
        RenderableObject.new  => "\x03\x00\x01\x61\x02\x00\x01\x62\x00\x00\x09"
      }

      test_run(@encoder, data)
    end

    it "should successfully encode a typed Renderable object" do
      data ={
        RenderableObject.new({'baz' => 'hello'}, "org.flails.spam")  => "\x10\x00\x0forg.flails.spam" + # object enclosure with type
                                                                          "\x00\x03baz" + # first attribute name
                                                                            "\x02\x00\x05hello" + # first attribute value
                                                                          "\x00\x00\x09" # object termination
      }

      test_run(@encoder, data)
    end
    
    it "should use references" do
      obj1 = RenderableObject.new({'baz' => 'hello'}, "org.flails.spam")
      obj2 = RenderableObject.new({'bar' => 'hello'}, "org.flails.spam")
      data ={
        [obj1, obj1, obj1]        => "\x0a\x00\x00\x00\x03\x10\x00\x0forg.flails.spam\x00\x03baz\x02\x00\x05hello\x00\x00\x09\x07\x00\x01\x07\x00\x01",
        [obj1, obj2, obj1, obj2]  => "\x0a\x00\x00\x00\x04\x10\x00\x0forg.flails.spam\x00\x03baz\x02\x00\x05hello\x00\x00\x09" +
                                     "\x10\x00\x0forg.flails.spam\x00\x03bar\x02\x00\x05hello\x00\x00\x09\x07\x00\x01\x07\x00\x02"
      }
      
      test_run(@encoder, data)
    end
    
  end
  
  describe "encoding arrays" do
    it "should successfully encode an array" do
      data = {
        []                  => "\x0a\x00\x00\x00\x00",
        [1, 2, 3]           => "\x0a\x00\x00\x00\x03" + # array enclosure
                                  "\x00\x3f\xf0\x00\x00\x00\x00\x00\x00" + # 1
                                  "\x00\x40\x00\x00\x00\x00\x00\x00\x00" + # 2
                                  "\x00\x40\x08\x00\x00\x00\x00\x00\x00" # 3        
      }
      
      test_run(@encoder, data)      
    end
    
    it "should use references" do
      arr1 = [1, 2, 3]
      arr2 = ["hello", "bar", "baz"]
      data = {
        [arr1, arr1]                  => "\x0a\x00\x00\x00\x02" + # enclosing array
                                            "\x0a\x00\x00\x00\x03" + # arr1 enclosure
                                              "\x00\x3f\xf0\x00\x00\x00\x00\x00\x00" + # 1
                                              "\x00\x40\x00\x00\x00\x00\x00\x00\x00" + # 2
                                              "\x00\x40\x08\x00\x00\x00\x00\x00\x00" + # 3
                                            "\x07\x00\x01", # ref to arr1
        [arr1, arr2, arr1, arr2]      => "\x0a\x00\x00\x00\x04" + # enclosing array
                                            "\x0a\x00\x00\x00\x03" + # arr1 enclosure
                                              "\x00\x3f\xf0\x00\x00\x00\x00\x00\x00" + # 1
                                              "\x00\x40\x00\x00\x00\x00\x00\x00\x00" + # 2
                                              "\x00\x40\x08\x00\x00\x00\x00\x00\x00" + # 3
                                            "\x0a\x00\x00\x00\x03" + # arr2 enclosure
                                              "\x02\x00\x05hello" + # hello
                                              "\x02\x00\x03bar" + # bar
                                              "\x02\x00\x03baz" + # baz
                                            "\x07\x00\x01\x07\x00\x02" # refs to arr1, arr2
      }

      test_run(@encoder, data)      
    end    
  end
  
  describe "encoding mixed objects" do
    it "should use references correctly for mixed objects with circular references" do
      arr1 = [1, 2, 3]
      obj1 = RenderableObject.new({'baz' => arr1}, "org.flails.spam")
      arr1[1] = obj1
      data = {
        arr1 => "\x0a\x00\x00\x00\x03" + # arr1 enclosure
                  "\x00\x3f\xf0\x00\x00\x00\x00\x00\x00" + # 1
                  "\x10\x00\x0forg.flails.spam" + # obj1 enclosure with type
                    "\x00\x03baz" + # first attribute name
                      "\x07\x00\x00" + # first attribute value (ref to arr1)
                    "\x00\x00\x09" + # object termination
                  "\x00\x40\x08\x00\x00\x00\x00\x00\x00" # 3
      }
      
      test_run(@encoder, data)      
    end
  end

  describe "encoding dates" do
    it "should successfully encode Date objects" do
      data = {
        Date.new(2003, 12, 1)   => "\x0b\x42\x6f\x25\xe2\xb2\x80\x00\x00\x00\x00"
      }
      
      test_run(@encoder, data)      
    end
    
    it "should successfully encode Time objects" do
      data = {
        Time.utc(2003, 12, 1)               => "\x0b\x42\x6f\x25\xe2\xb2\x80\x00\x00\x00\x00",
        Time.utc(2005, 3, 18, 1, 58, 31)    => "\x0b\x42\x70\x2b\x36\x21\x15\x80\x00\x00\x00"
      }
      
      test_run(@encoder, data)            
    end

    it "should successfully encode DateTime objects" do
      data = {
        DateTime.parse("2003-12-1")         => "\x0b\x42\x6f\x25\xe2\xb2\x80\x00\x00\x00\x00",
        DateTime.parse("2005-3-18 1:58:31") => "\x0b\x42\x70\x2b\x36\x21\x15\x80\x00\x00\x00"
      }
      
      test_run(@encoder, data)            
    end
  end

  # @TODO: XML Support

end