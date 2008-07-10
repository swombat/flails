require 'lib/flails/io/amf0/types'

describe Flails::IO::AMF0::Types do

  it "should hold the correct AMF0 type values" do
    Flails::IO::AMF0::Types::NUMBER.should          == 0x00
    Flails::IO::AMF0::Types::BOOL.should            == 0x01
    Flails::IO::AMF0::Types::STRING.should          == 0x02
    Flails::IO::AMF0::Types::OBJECT.should          == 0x03
    Flails::IO::AMF0::Types::MOVIECLIP.should       == 0x04  
    Flails::IO::AMF0::Types::NULL.should            == 0x05
    Flails::IO::AMF0::Types::UNDEFINED.should       == 0x06  
    Flails::IO::AMF0::Types::REFERENCE.should       == 0x07  
    Flails::IO::AMF0::Types::MIXEDARRAY.should      == 0x08   
    Flails::IO::AMF0::Types::OBJECTTERM.should      == 0x09   
    Flails::IO::AMF0::Types::ARRAY.should           == 0x0a
    Flails::IO::AMF0::Types::DATE.should            == 0x0b
    Flails::IO::AMF0::Types::LONGSTRING.should      == 0x0c   
    Flails::IO::AMF0::Types::UNSUPPORTED.should     == 0x0d    
    Flails::IO::AMF0::Types::RECORDSET.should       == 0x0e  
    Flails::IO::AMF0::Types::XML.should             == 0x0f
    Flails::IO::AMF0::Types::TYPEDOBJECT.should     == 0x10    
    Flails::IO::AMF0::Types::AMF3.should            == 0x11
  end
  
end