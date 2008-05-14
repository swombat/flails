require 'lib/ruby_amf/io/amf0/encoder'
require 'lib/ruby_amf/io/util/undefined_type'

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

describe RubyAMF::IO::AMF0::Encoder do
  include AMF0EncoderHelper
  
  before(:each) do
    @encoder = RubyAMF::IO::AMF0::Encoder.new    
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
        RubyAMF::IO::Util::UndefinedType.new  => "\x06"
      }
      
      test_run(@encoder, data)
    end
  end
  
  
  describe "encoding objects" do
    it "should successfully encode a hash" do
      data = {
        {'a' => 'a'}         => "\x03\x00\x01\x61\x02\x00\x01\x61\x00\x00\x09",
        {'a' => 'b'}         => "\x03\x00\x01\x61\x02\x00\x01\x62\x00\x00\x09"
      }
      
      test_run(@encoder, data)
    end
  end
end