require 'lib/ruby_amf/io/amf0/types'

describe RubyAMF::IO::AMF0::Types do

  it "should hold the correct AMF0 type values" do
    RubyAMF::IO::AMF0::Types::NUMBER.should          == 0x00
    RubyAMF::IO::AMF0::Types::BOOL.should            == 0x01
    RubyAMF::IO::AMF0::Types::STRING.should          == 0x02
    RubyAMF::IO::AMF0::Types::OBJECT.should          == 0x03
    RubyAMF::IO::AMF0::Types::MOVIECLIP.should       == 0x04  
    RubyAMF::IO::AMF0::Types::NULL.should            == 0x05
    RubyAMF::IO::AMF0::Types::UNDEFINED.should       == 0x06  
    RubyAMF::IO::AMF0::Types::REFERENCE.should       == 0x07  
    RubyAMF::IO::AMF0::Types::MIXEDARRAY.should      == 0x08   
    RubyAMF::IO::AMF0::Types::OBJECTTERM.should      == 0x09   
    RubyAMF::IO::AMF0::Types::ARRAY.should           == 0x0a
    RubyAMF::IO::AMF0::Types::DATE.should            == 0x0b
    RubyAMF::IO::AMF0::Types::LONGSTRING.should      == 0x0c   
    RubyAMF::IO::AMF0::Types::UNSUPPORTED.should     == 0x0d    
    RubyAMF::IO::AMF0::Types::RECORDSET.should       == 0x0e  
    RubyAMF::IO::AMF0::Types::XML.should             == 0x0f
    RubyAMF::IO::AMF0::Types::TYPEDOBJECT.should     == 0x10    
    RubyAMF::IO::AMF0::Types::AMF3.should            == 0x11
  end
  
end