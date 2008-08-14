require 'lib/ruby_amf/filters/amf_serializer_filter'
require 'lib/ruby_amf/filters/amf_deserializer_filter'

module AMFDeserializerFilterSpecHelper
  def test_run(writer, data, method)
    data.each do |key, value|
      stream = ""
      writer.stream = stream
      writer.write(method, key)
      stream.should == value
    end
  end
end

describe RubyAMF::Filters::AMFDeserializerFilter do
  include AMFDeserializerFilterSpecHelper
  
  before(:each) do
    ClassMappings.should_receive(:use_flails_serializer).and_return(true)
    @serializer = RubyAMF::Filters::AMFSerializerFilter.new
  end
  
  describe "encoding a Ping" do
    it "should successfully encode the ping" do
      @amf_object = RubyAMF::App::AMFObject.new
    end
  end
  
end