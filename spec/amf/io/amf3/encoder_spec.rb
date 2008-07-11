require 'spec/spec_helper'

describe Flails::IO::AMF3::Encoder do
  include AMFEncoderHelper
  
  before(:each) do
    @encoder = Flails::IO::AMF3::Encoder.new    
  end
  
  
  describe "encoding primitives" do
    it "should successfully encode numbers" do
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
        268435455   => "\x04\xbf\xff\xff\xff",
        -1          => "\x04\xff\xff\xff\xff",
        -42         => "\x04\xff\xff\xff\xd6",
        -268435456  => "\x04\xc0\x80\x80\x00"
      }
      
      test_run(@encoder, data)
    end  
  end

end