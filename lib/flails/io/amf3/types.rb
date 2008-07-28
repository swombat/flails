module Flails
  module IO
    module AMF3
      module Types
        UNDEFINED           = 0x00
        NULL                = 0x01
        BOOL_FALSE          = 0x02
        BOOL_TRUE           = 0x03
        INTEGER             = 0x04
        NUMBER              = 0x05
        STRING              = 0x06
        XML                 = 0x07
        DATE                = 0x08
        ARRAY               = 0x09
        OBJECT              = 0x0a
        XMLSTRING           = 0x0b
        BYTEARRAY           = 0x0c
        
        OBJECT_STATIC       = 0x00
        OBJECT_EXTERNAL     = 0x01
        OBJECT_DYNAMIC      = 0x02
        OBJECT_PROXY        = 0x03
      end
    end
  end
end

