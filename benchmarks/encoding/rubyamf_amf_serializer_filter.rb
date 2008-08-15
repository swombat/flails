require 'rubygems'
require 'activesupport'

require 'date'

$LOAD_PATH << "../../lib"

Dependencies.load_paths = $LOAD_PATH

require 'config/rubyamf_props'
require 'config/rubyamf_config'
require 'config/test_classes'


@test_data = []
2000.times { @test_data << MockFile.new }

@amf_object = RubyAMF::App::AMFObject.new
@amf_object.input_stream = "-"
  
@amf_body = RubyAMF::App::AMFBody.new
@amf_body.special_handling = "-"
@amf_body.response_uri = "/1/onResult"
@amf_body.value = [
  { "timestamp"=>0, "correlationId"=>nil, 
    "messageId"=>"C0B6FD1F-E7FF-E509-BD1A-C146073346D2", 
    "body"=>{}, "timeToLive"=>0, "destination"=>nil, 
    "operation"=>5, "clientId"=>nil, 
    "headers"=>{:DSId=>"nil", :DSMessagingVersion=>1}
  }]
@amf_body.results =   {
    "correlationId"=>"C0B6FD1F-E7FF-E509-BD1A-C146073346D2", 
    "timestamp"=>"Thu Aug 14 13:52:17 +0100 200800", "timeToLive"=>0, 
    "body"=>@test_data, "messageId"=>"b6223240-86b7-cb8e-5a15-9e65d6120b17", 
    "destination"=>nil, "headers"=>{}, "clientId"=>"dfd3a556-e1ab-b01e-6f63-f83474567354"
    }
@amf_body.response_index = "/1"
@amf_body.meta = {"messageId"=>"C0B6FD1F-E7FF-E509-BD1A-C146073346D2", "clientId"=>nil}
@amf_object.bodies << @amf_body
@amf_object.output_stream = ""


@serializer = RubyAMF::Filters::AMFSerializerFilter.new

RubyAMF::Configuration::ClassMappings.use_flails_serializer = false

puts "Without Flails"
start = Time.now.to_f
puts "Started - #{start}"
@serializer.run(@amf_object)
puts "Finished - #{Time.now.to_f - start}"

RubyAMF::Configuration::ClassMappings.use_flails_serializer = true

puts "With Flails"
start = Time.now.to_f
puts "Started - #{start}"
@serializer.run(@amf_object)
puts "Finished - #{Time.now.to_f - start}"
