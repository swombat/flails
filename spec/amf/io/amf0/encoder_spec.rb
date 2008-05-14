require 'lib/ruby_amf/io/amf0/encoder'

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
  
end