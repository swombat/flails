module RubyAMF
  module IO
    module Constants
      #AMF0
      AMF_NUMBER = 0x00
      AMF_BOOLEAN = 0x01
      AMF_STRING = 0x02
      AMF_OBJECT = 0x03
      AMF_MOVIE_CLIP = 0x04
      AMF_NULL = 0x05
      AMF_UNDEFINED = 0x06
      AMF_REFERENCE = 0x07
      AMF_MIXED_ARRAY = 0x08
      AMF_EOO = 0x09
      AMF_ARRAY = 0x0A
      AMF_DATE = 0x0B
      AMF_LONG_STRING = 0x0C
      AMF_UNSUPPORTED = 0x0D
      AMF_RECORDSET = 0x0E
      AMF_XML = 0x0F
      AMF_TYPED_OBJECT = 0x10

      #AMF3
      AMF3_TYPE = 0x11
      AMF3_UNDEFINED = 0x00
      AMF3_NULL = 0x01
      AMF3_FALSE = 0x02
      AMF3_TRUE = 0x03
      AMF3_INTEGER = 0x04
      AMF3_NUMBER = 0x05
      AMF3_STRING = 0x06
      AMF3_XML = 0x07
      AMF3_DATE = 0x08
      AMF3_ARRAY = 0x09
      AMF3_OBJECT = 0x0A
      AMF3_XML_STRING = 0x0B
      AMF3_BYTE_ARRAY = 0x0C
      AMF3_INTEGER_MAX = 268435455
      AMF3_INTEGER_MIN = -268435456
    end
  end
end