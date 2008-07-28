require 'lib/flails/io/amf3/types'

describe Flails::IO::AMF3::Types do

  it "should hold the correct AMF3 type values" do
    Flails::IO::AMF3::Types::UNDEFINED.should   == 0x00
    Flails::IO::AMF3::Types::NULL.should        == 0x01
    Flails::IO::AMF3::Types::BOOL_FALSE.should  == 0x02
    Flails::IO::AMF3::Types::BOOL_TRUE.should   == 0x03
    Flails::IO::AMF3::Types::INTEGER.should     == 0x04  
    Flails::IO::AMF3::Types::NUMBER.should      == 0x05
    Flails::IO::AMF3::Types::STRING.should      == 0x06  
    Flails::IO::AMF3::Types::XML.should         == 0x07  
    Flails::IO::AMF3::Types::DATE.should        == 0x08   
    Flails::IO::AMF3::Types::ARRAY.should       == 0x09   
    Flails::IO::AMF3::Types::OBJECT.should      == 0x0a
    Flails::IO::AMF3::Types::XMLSTRING.should   == 0x0b
    Flails::IO::AMF3::Types::BYTEARRAY.should   == 0x0c
    
    Flails::IO::AMF3::Types::OBJECT_STATIC      == 0x00
    Flails::IO::AMF3::Types::OBJECT_EXTERNAL    == 0x01
    Flails::IO::AMF3::Types::OBJECT_DYNAMIC     == 0x02
    Flails::IO::AMF3::Types::OBJECT_PROXY       == 0x03
    
  end
  
end