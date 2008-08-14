require 'spec/spec_helper'

require 'lib/flails/io/filter/amf_serializer_filter'
require 'lib/ruby_amf/app/amf_object'
require 'lib/ruby_amf/app/amf_body'

module AMFSerializerFilterSpecHelper
end

describe Flails::IO::Filter::AMFSerializerFilter do
  include AMFSerializerFilterSpecHelper
  
  before(:each) do
    @serializer = Flails::IO::Filter::AMFSerializerFilter.new
  end
  
  describe "encoding a Ping" do
    before(:each) do
      @amf_object = RubyAMF::App::AMFObject.new
      @amf_object.input_stream = "\000\003\000\000\000\001\000\004null\000\002/1\000\000\000?" +
        "\000\000\001\021\n\201\023Mflex.messaging.messages.CommandMessage\023operation\ecorr" + 
        "elationId\023timestamp\025timeToLive\tbody\017headers\027destination\023messageId\021" +
        "clientId\004\005\006\001\004\000\004\000\n\v\001\001\n\005%DSMessagingVersion\004\001" +
        "\tDSId\006\anil\001\006\001\006IA35040A2-D025-A3EF-BEDB-C1479CD8D41B\001"
        
      @amf_body = RubyAMF::App::AMFBody.new
      @amf_body.special_handling = "Ping"
      @amf_body.response_uri = "/1/onResult"
      @amf_body.value = [
        { "timestamp"=>0, "correlationId"=>nil, 
          "messageId"=>"C0B6FD1F-E7FF-E509-BD1A-C146073346D2", 
          "body"=>{}, "timeToLive"=>0, "destination"=>nil, 
          "operation"=>5, "clientId"=>nil, 
          "headers"=>{:DSId=>"nil", :DSMessagingVersion=>1}
        }]
      @amf_body.results = {
        "correlationId"=>"C0B6FD1F-E7FF-E509-BD1A-C146073346D2", 
        "timestamp"=>"Thu Aug 14 13:52:17 +0100 200800", "timeToLive"=>0, 
        "body"=>nil, "messageId"=>"b6223240-86b7-cb8e-5a15-9e65d6120b17", 
        "destination"=>nil, "headers"=>{}, "clientId"=>"dfd3a556-e1ab-b01e-6f63-f83474567354"
        }
      @amf_body.response_index = "/1"
      @amf_body.meta = {"messageId"=>"C0B6FD1F-E7FF-E509-BD1A-C146073346D2", "clientId"=>nil}
      @amf_object.bodies << @amf_body
      @amf_object.output_stream = ""
    end
    
    it "should successfully encode the ping" do
      @serializer.serialize(@amf_object)
      @amf_object.output_stream.should == "\000\003\000\000\000\001\000\v/1/onResult\000\004" +
        "null\377\377\377\377\021\n\201\003Uflex.messaging.messages.AcknowledgeMessage\023ti" +
        "mestamp\ecorrelationId\023messageId\tbody\025timeToLive\027destination\021clientId" + 
        "\017headers\006AThu Aug 14 13:52:17 +0100 200800\006IC0B6FD1F-E7FF-E509-BD1A-C14607" +
        "3346D2\006Ib6223240-86b7-cb8e-5a15-9e65d6120b17\001\004\000\001\006Idfd3a556-e1ab-b" +
        "01e-6f63-f83474567354\t\001\001"
    end
  end
  
end