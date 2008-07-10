require 'date'
require 'lib/flails/io/amf0/encoder'
require 'lib/flails/io/util/undefined_type'
require 'lib/flails/app/model/renderable'

module AMF0EncoderHelper
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

describe Flails::IO::AMF0::Encoder do
  include AMF0EncoderHelper
  
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
        RenderableObject.new({'baz' => 'hello'}, "org.flails.spam")  => "\x10\x00\x0forg.flails.spam\x00\x03baz\x02\x00\x05hello\x00\x00\x09"
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
        [1, 2, 3]           => "\x0a\x00\x00\x00\x03\x00\x3f\xf0\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x40\x08\x00\x00\x00\x00\x00\x00"
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