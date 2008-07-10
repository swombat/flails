require 'lib/flails/io/util/big_endian_writer'

module BigEndianWriterHelper
  def test_run(writer, data, method)
    data.each do |key, value|
      stream = ""
      writer.stream = stream
      writer.write(method, key)
      stream.should == value
    end
  end
end

describe Flails::IO::Util::BigEndianWriter do
  include BigEndianWriterHelper
  
  before(:each) do
    @writer = Flails::IO::Util::BigEndianWriter.new
  end
  
  describe "writing single bytes" do
    it "should successfully write unsigned characters" do
      data = {
        0           => "\x00",
        2           => "\x02",
        50          => "\x32",
        120         => "\x78",
        200         => "\xc8",
        255         => "\xff"
      }
      
      test_run(@writer, data, :uchar)
    end

    it "should successfully write signed characters" do
      data = {
        0           => "\x00",
        2           => "\x02",
        50          => "\x32",
        -50         => "\xce",
        -128        => "\x80",
        -127        => "\x81",
        127         => "\x7f"
      }
      
      test_run(@writer, data, :char)
    end
  end
  
  describe "writing shorts (16 bits)" do
    it "should successfully write unsigned shorts" do
      data = {
        0           => "\x00\x00",
        2           => "\x00\x02",
        255         => "\x00\xff",
        3000        => "\x0b\xb8",
        64000       => "\xfa\x00",
        65535       => "\xff\xff"
      }
      
      test_run(@writer, data, :ushort)      
    end

    it "should successfully write signed shorts" do
      data = {
        0           => "\x00\x00",
        2           => "\x00\x02",
        255         => "\x00\xff",
        -3000       => "\xf4\x48",
        -32767      => "\x80\x01",
        32767       => "\x7f\xff"
      }
      
      test_run(@writer, data, :short)
    end
  end

  describe "writing ints/longs (32 bits)" do
    it "should successfully write unsigned ints" do
      data = {
        0           => "\x00\x00\x00\x00",
        2           => "\x00\x00\x00\x02",
        255         => "\x00\x00\x00\xff",
        3000        => "\x00\x00\x0b\xb8",
        64000       => "\x00\x00\xfa\x00",
        65535       => "\x00\x00\xff\xff",
        4294967295  => "\xff\xff\xff\xff"
      }
      
      test_run(@writer, data, :uint)
      test_run(@writer, data, :ulong)
    end

    it "should successfully write signed ints" do
      data = {
        0           => "\x00\x00\x00\x00",
        2           => "\x00\x00\x00\x02",
        255         => "\x00\x00\x00\xff",
        -2147483647 => "\x80\x00\x00\x01",
        2147483647  => "\x7f\xff\xff\xff"
      }
      
      test_run(@writer, data, :int)
      test_run(@writer, data, :long)
    end
  end

  describe "writing floats" do
    it "should successfully write positive floats" do
      data = {
        0.1         => "\x3d\xcc\xcc\xcd",
        1000        => "\x44\x7a\x00\x00",
        1           => "\x3f\x80\x00\x00",
        3.141592    => "\x40\x49\x0f\xd8",
        9_999_999   => "\x4b\x18\x96\x7f"
      }
      
      test_run(@writer, data, :float)
    end

    it "should successfully write negative floats" do
      data = {
        -0.1         => "\xbd\xcc\xcc\xcd",
        -1000        => "\xc4\x7a\x00\x00",
        -1           => "\xbf\x80\x00\x00",
        -3.141592    => "\xc0\x49\x0f\xd8",
        -9_999_999   => "\xcb\x18\x96\x7f"
      }
      
      test_run(@writer, data, :float)
    end
  end

  describe "writing doubles" do
    it "should successfully write positive doubles" do
      data = {
        0.1         => "\x3f\xb9\x99\x99\x99\x99\x99\x9a",
        1000        => "\x40\x8f\x40\x00\x00\x00\x00\x00",
        1           => "\x3f\xf0\x00\x00\x00\x00\x00\x00",
        3.141592    => "\x40\x09\x21\xfa\xfc\x8b\x00\x7a",
        9_999_999   => "\x41\x63\x12\xcf\xe0\x00\x00\x00"
      }
      
      test_run(@writer, data, :double)
    end

    it "should successfully write negative doubles" do
      data = {
        -0.1         => "\xbf\xb9\x99\x99\x99\x99\x99\x9a",
        -1000        => "\xc0\x8f\x40\x00\x00\x00\x00\x00",
        -1           => "\xbf\xf0\x00\x00\x00\x00\x00\x00",
        -3.141592    => "\xc0\x09\x21\xfa\xfc\x8b\x00\x7a",
        -9_999_999   => "\xc1\x63\x12\xcf\xe0\x00\x00\x00"
      }
      
      test_run(@writer, data, :double)
    end
  end
  
  describe "writing utf-8 strings" do
    it "should correctly encode a utf-8 string" do
      data = {
        "Καλημέρα"    => "\xce\x9a\xce\xb1\xce\xbb\xce\xb7\xce\xbc\xce\xad\xcf\x81\xce\xb1",
        "κόσμε"       => "\xce\xba\xcf\x8c\xcf\x83\xce\xbc\xce\xb5",
        "abcdef"      => "abcdef"
      }
      
      test_run(@writer, data, :string)
    end
  end

  
end