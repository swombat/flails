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
        ["Hello", "Hello", "Hello"]           => "\x09\x07\x01\x06\x0bHello\x06\x00\x06\x00",
        ["Hello", "Hella", "Hello", "Hella"]  => "\x09\x09\x01\x06\x0bHello\x06\x0bHella\x06\x00\x06\x02"
      }

      test_run(@encoder, data)      
    end
    
    it "should not record a reference for empty strings" do
      data = {
        ["Hello", "", ""]                     => "\x09\x07\x01\x06\x0bHello\x06\x01\x06\x01"
      }

      test_run(@encoder, data)      
    end

    it "should not mix string references with other types of references" do
      data = {
        [["Hello"], "Hello", "", ""]                     => "\x09\x09\x01\x09\x03\x01\x06\x0bHello\x06\x00\x06\x01\x06\x01"
      }

      test_run(@encoder, data)      
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
        [array1, array1]      => "\x09\x05\x01\x09\x09\x01\x04\x01\x04\x02\x04\x03\x04\x04\x09\x02"
      }

      test_run(@encoder, data)
    end
  end
  
  describe "encoding dates" do
    it "should successfully encode Date objects" do
      data = {
        Date.new(2003, 12, 1)   => "\x08\x01\x42\x6f\x25\xe2\xb2\x80\x00\x00"
      }
      
      test_run(@encoder, data)      
    end
    
    it "should successfully encode Time objects" do
      data = {
        Time.utc(2003, 12, 1)               => "\x08\x01\x42\x6f\x25\xe2\xb2\x80\x00\x00",
        Time.utc(2005, 3, 18, 1, 58, 31)    => "\x08\x01\x42\x70\x2b\x36\x21\x15\x80\x00"
      }
      
      test_run(@encoder, data)            
    end

    it "should successfully encode DateTime objects" do
      data = {
        DateTime.parse("2003-12-1")         => "\x08\x01\x42\x6f\x25\xe2\xb2\x80\x00\x00",
        DateTime.parse("2005-3-18 1:58:31") => "\x08\x01\x42\x70\x2b\x36\x21\x15\x80\x00"
      }
      
      test_run(@encoder, data)            
    end
    
    it "should use references for dates" do
      date = Time.utc(2003, 12, 1)
      
      data = {
        [date, date]              => "\x09\x05\x01\x08\x01\x42\x6f\x25\xe2\xb2\x80\x00\x00\x08\x02"
      }
      
      test_run(@encoder, data)
    end
  end
  
  describe "encoding hashes" do
    it "should be able to encode hashes" do
      data = {
        { 'a' => 'a',
          'b' => 'b',
          'c' => 'c',
          'd' => 'd' }                          =>  "\x09\x01\x03a\x06\x00\x03b\x06\x02\x03c\x06\x04\x03d\x06\x06\x01",
        { 'a' => 1,
          'b' => 2 }                            =>  "\x09\x01\x03a\x04\x01\x03b\x04\x02\x01",
        { "Hello" => Time.utc(2003, 12, 1),
          "Hallo" => [0, 1, 2, 3] }             =>  "\x09\x01" + "\x0bHello" + "\x08\x01\x42\x6f\x25\xe2\xb2\x80\x00\x00" +
                                                    "\x0bHallo" + "\x09\x09\x01\x04\x00\x04\x01\x04\x02\x04\x03" +
                                                    "\x01"
      }

      test_run(@encoder, data)
    end
    
    it "should not accept empty strings as keys" do
      data = {
        { 'a' => 'a',
          ''  => 'b'}   => "x"
      }
      
      lambda { test_run(@encoder, data) }.should raise_error Flails::IO::InvalidInputException
    end
    
    it "should support recursive hash references" do
      hash = { "Hello" => "World" }
      hash["a"] = hash
      data = {
        hash => "\x09\x01" + "\x0bHello" + "\x06\x0bWorld" +    # Hash + key 'Hello' + value 'World'
                "\x03a" + "\x09\x00" + "\x01"                       # key 'a' + reference 0 + end-of-hash
      }
      
      test_run(@encoder, data)
    end
  end
    
  describe "using references for a variety of object" do
    it "should not mix string references with array or date references" do
      data = {
        [Time.utc(2003, 12, 1), ["Hello"], "Hello", ""] => "\x09\x09\x01\x08\x01\x42\x6f\x25\xe2\xb2\x80\x00\x00\x09\x03\x01\x06\x0bHello\x06\x00\x06\x01"
      }

      test_run(@encoder, data)
    end

    it "should not mix string references with hash references" do
      hash = {"Hello" => "World"}
      data = {
        [hash, "Hello", hash, "World"] => "\x09\x09\x01" +                                          # Array
                                          "\x09\x01" + "\x0bHello" + "\x06\x0bWorld" + "\x01" +     # hash
                                          "\x06\x00" +                                              # ref for "Hello"
                                          "\x09\x02" +                                              # ref for hash
                                          "\x06\x02"
      }

      test_run(@encoder, data)
    end
        
    it "should use the same reference count for arrays and dates" do
      date = Time.utc(2003, 12, 1)
      
      data = {
        [date, date]              => "\x09\x05\x01\x08\x01\x42\x6f\x25\xe2\xb2\x80\x00\x00\x08\x02"
      }
      
      test_run(@encoder, data)
    end

    it "should use the same references for arrays and hashes" do
      hash = {"Hello" => "World"}
      array = [hash, hash]
      hash["a"] = array
      
      data = {
        [array, hash]     =>  "\x09\x05\x01" +                        # Enclosing array of 2 elements
                                "\x09\x05\x01" +                      # array
                                  "\x09\x01" +                        # hash
                                    "\x0bHello" + "\x06\x0bWorld" +   # "Hello" => "World"
                                    "\x03a" + "\x09\x02" +            # "a" => ref for array
                                  "\x01" +                            # end of hash
                                  "\x09\x04" +                        # ref for hash
                                "\x09\x04"                            # ref for hash
      }

      test_run(@encoder, data)
    end
  end
  
end