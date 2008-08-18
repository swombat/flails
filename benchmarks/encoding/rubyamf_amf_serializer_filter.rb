require 'rubygems'
require 'activesupport'

require 'date'

$LOAD_PATH << "../../lib"

Dependencies.load_paths = $LOAD_PATH

require 'config/rubyamf_props'
require 'config/rubyamf_config'
require 'config/test_classes'


@test_data = []

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

def run(with_flails)
  RubyAMF::Configuration::ClassMappings.use_flails_serializer = with_flails
  start = Time.now.to_f
  @serializer.run(@amf_object)
  return Time.now.to_f - start
end

@results_without_flails = []
@results_with_flails = []

@test_points = [100, 500, 1000, 2000, 5000, 10000]

@test_points.each do |objects|
  puts "Objects: #{objects}"
  objects.times { @test_data << MockFile.new }
  wo = run(false).round_with_precision(3)
  puts "Without: #{wo}"
  @results_without_flails << wo
  w = run(true).round_with_precision(3)
  puts "With: #{w}"
  @results_with_flails << w
end

puts "Objects:\t#{@test_points.join("\t")}"
puts "RubyAMF:\t#{@results_without_flails.join("\t")}"
puts "Flails:\t\t#{@results_with_flails.join("\t")}"



# Historical...
# Initial state:
# Objects:  100 500 1000  2000
# RubyAMF:  0.051 0.185 0.486 1.002
# Flails:   0.08  0.901 5.759 27.545
#
# Notes:
# This is a heavily optimised version of RubyAMF, not vanilla, which performs much worse
# This is Flails at the point where it's not had any optimisations whatsoever, still uses an Array for references, etc.
#
# After switching from using an Array to using a Hash - 95% improvement already
# Objects:  100 500 1000  2000  5000  10000
# RubyAMF:  0.05  0.179 0.502 0.993 2.003 4.065
# Flails:   0.061 0.208 0.629 1.139 3.532 6.864
#
