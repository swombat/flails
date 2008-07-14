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
        ""                                    => "\x06\x01",
        "hello"                               => "\x06\x0bhello",
        "ᚠᛇᚻ"                                 => "\x06\x13\xe1\x9a\xa0\xe1\x9b\x87\xe1\x9a\xbb",
        "Καλημέρα"                            => "\x06\x21\xce\x9a\xce\xb1\xce\xbb\xce\xb7\xce\xbc\xce\xad\xcf\x81\xce\xb1",
        "ღმერთსი შემვედრე, ნუთუ კვლ" +
        "ა დამხსნას სოფლისა შრომასა, ცეცხლს"  =>  "\x06\x82\x45\xe1\x83\xa6\xe1\x83\x9b\xe1\x83\x94\xe1\x83\xa0" +
                                                  "\xe1\x83\x97\xe1\x83\xa1\xe1\x83\x98\x20\xe1\x83\xa8\xe1\x83" +
                                                  "\x94\xe1\x83\x9b\xe1\x83\x95\xe1\x83\x94\xe1\x83\x93\xe1\x83" +
                                                  "\xa0\xe1\x83\x94\x2c\x20\xe1\x83\x9c\xe1\x83\xa3\xe1\x83\x97" +
                                                  "\xe1\x83\xa3\x20\xe1\x83\x99\xe1\x83\x95\xe1\x83\x9a\xe1\x83" +
                                                  "\x90\x20\xe1\x83\x93\xe1\x83\x90\xe1\x83\x9b\xe1\x83\xae\xe1" +
                                                  "\x83\xa1\xe1\x83\x9c\xe1\x83\x90\xe1\x83\xa1\x20\xe1\x83\xa1" +
                                                  "\xe1\x83\x9d\xe1\x83\xa4\xe1\x83\x9a\xe1\x83\x98\xe1\x83\xa1" +
                                                  "\xe1\x83\x90\x20\xe1\x83\xa8\xe1\x83\xa0\xe1\x83\x9d\xe1\x83" +
                                                  "\x9b\xe1\x83\x90\xe1\x83\xa1\xe1\x83\x90\x2c\x20\xe1\x83\xaa" +
                                                  "\xe1\x83\x94\xe1\x83\xaa\xe1\x83\xae\xe1\x83\x9a\xe1\x83\xa1"
      }
      
      test_run(@encoder, data)
    end
    
    it "should use references for strings" do
      data = {
        ["Hello", "Hello", "Hello"]           => "\x09\x07\x01\x06\x0bHello\x06\x00\x06\x00"
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
  
  describe "encoding arrays" do
    it "should successfully encode simple arrays" do
      data = {
        [0, 1, 2, 3]          => "\x09\x09\x01\x04\x00\x04\x01\x04\x02\x04\x03",
        ["Hello", 2, 3, 4, 5] => "\x09\x0b\x01\x06\x0b\x48\x65\x6c\x6c\x6f\x04\x02\x04\x03\x04\x04\x04\x05"
      }
      
      test_run(@encoder, data)
    end
    
    it "should use references with arrays" do
      array1 = [1, 2, 3, 4]
      
      data = {
        [array1, array1]      => "\x09\x05\x01\x09\x09\x01\x04\x00\x04\x01\x04\x02\x04\x03\x00"
      }
      
    end
    
  end
  
end