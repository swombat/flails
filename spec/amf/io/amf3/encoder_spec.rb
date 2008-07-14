require 'spec/spec_helper'

describe Flails::IO::AMF3::Encoder do
  include AMFEncoderHelper
  
  before(:each) do
    @encoder = Flails::IO::AMF3::Encoder.new    
  end
  
  
  describe "encoding primitives" do
    it "should successfully encode positive integers" do
      data = {
        0           => "\x04\x00",
        53          => "\x04\x35",
        127         => "\x04\x7f",
        128         => "\x04\x81\x00",
        212         => "\x04\x81\x54",
        16383       => "\x04\xff\x7f",
        16384       => "\x04\x81\x80\x00",
        107839      => "\x04\x86\xca\x3f",
        2097151     => "\x04\xff\xff\x7f",
        2097152     => "\x04\x80\xc0\x80\x00",
        268435455   => "\x04\xbf\xff\xff\xff"
      }
      
      test_run(@encoder, data)
    end  
        
    it "should successfully encode negative integers" do
      data = {
        -1          => "\x04\xff\xff\xff\xff",
        -42         => "\x04\xff\xff\xff\xd6",
        -268435456  => "\x04\xc0\x80\x80\x00"
      }
      
      test_run(@encoder, data)
    end
    
    it "should encode integers that are out of range of the 29-bit variable-length encoding as doubles" do
      data = {
        268435456   => "\x05\x41\xb0\x00\x00\x00\x00\x00\x00",
        -268435457  => "\x05\xc1\xb0\x00\x00\x01\x00\x00\x00"
      }
      
      test_run(@encoder, data)      
    end

    it "should successfully encode floating point numbers" do
      data = {
        0.1         => "\x05\x3f\xb9\x99\x99\x99\x99\x99\x9a",
        0.123456789 => "\x05\x3f\xbf\x9a\xdd\x37\x39\x63\x5f"
      }
      
      test_run(@encoder, data)
    end
  end
  
  describe "encoding special values" do
    it "should successfully encode nulls" do
      data = {
        nil         => "\x01"
      }
      
      test_run(@encoder, data)
    end

    it "should successfully encode undefined values" do
      data = {
        Flails::IO::Util::UndefinedType.new  => "\x00"
      }
      
      test_run(@encoder, data)
    end

    it "should successfully encode booleans" do
      data = {
        true         => "\x03",
        false        => "\x02"
      }
      
      test_run(@encoder, data)
    end
  end
  
  describe "encoding strings" do
    it "should successfully encode short strings" do
      data = {
        ""          => "\x06\x01",
        "hello"     => "\x06\x0bhello",
        "ᚠᛇᚻ"       => "\x06\x13\xe1\x9a\xa0\xe1\x9b\x87\xe1\x9a\xbb",
        "Καλημέρα"  => "\x06\x21\xce\x9a\xce\xb1\xce\xbb\xce\xb7\xce\xbc\xce\xad\xcf\x81\xce\xb1"
      }
      
      test_run(@encoder, data)
    end
    
    it "should not record a reference for empty strings" do
      # TODO
    end

    # it "should successfully encode long strings" do
    #   data = {
    #     "12"*40000  => "\x0c\x00\x01\x38\x80#{'12'*40000}"
    #   }
    #   
    #   test_run(@encoder, data)      
    # end
  end
  

end