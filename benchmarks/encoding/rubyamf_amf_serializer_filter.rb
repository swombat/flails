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
@frac_results_without_flails = []
@frac_results_with_flails = []
@rel_results = []
@frac_rel_results = []

@test_points = [100, 500, 1000, 2000, 5000, 10000, 20000]

@test_points.each do |objects|
  puts "Setting up test data (#{objects} objects)..."
  @test_data.clear
  objects.times { @test_data << MockFile.new }
  puts "Done - #{@test_data.length}"
  puts "RubyAMF..."
  w = run(false)
  @results_without_flails << w.round_with_precision(3)
  @frac_results_without_flails << (w * 1000 / objects).round_with_precision(3)
  puts "Done in #{w} seconds (#{(w / objects)} per object)"
  puts "Flails..."
  wo = run(true)
  @results_with_flails << wo.round_with_precision(3)
  @frac_results_with_flails << (wo* 1000 / objects).round_with_precision(3)
  #@rel_results << "#{((wo / w)*100).round_with_precision(2)}%"
  @frac_rel_results << "#{(((wo/objects) / (w/objects))*100).round_with_precision(2)}%"
  puts "Done in #{wo} seconds (#{(wo / objects)} per object)"
end

puts "Objects:\t#{@test_points.join("\t")}"
puts "RubyAMF:\t#{@results_without_flails.join("\t")}"
puts "Flails:\t\t#{@results_with_flails.join("\t")}"
#puts "Diff %:\t\t#{@rel_results.join("\t")}"

puts "--------------------------"

puts "Fractional results (ms):"
puts "Objects:\t#{@test_points.join("\t")}"
puts "RubyAMF:\t#{@frac_results_without_flails.join("\t")}"
puts "Flails:\t\t#{@frac_results_with_flails.join("\t")}"
puts "Diff %:\t\t#{@frac_rel_results.join("\t")}"

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
# ## 1
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.056 0.168 0.317 0.714 1.355 2.493 4.081
# Flails:   0.063 0.176 0.41  0.736 1.913 4.921 8.244
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.56  0.336 0.317 0.357 0.271 0.249 0.204
# Flails:   0.626 0.351 0.41  0.368 0.383 0.492 0.412
# 
# ## 2
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.07  0.172 0.321 0.73  1.504 2.441 4.18
# Flails:   0.076 0.178 0.407 0.666 1.869 5.028 8.166
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.696 0.344 0.321 0.365 0.301 0.244 0.209
# Flails:   0.764 0.355 0.407 0.333 0.374 0.503 0.408
# 
# ## 3
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.058 0.177 0.333 0.708 1.285 2.521 4.051
# Flails:   0.066 0.213 0.385 0.596 1.969 4.948 8.193
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.583 0.354 0.333 0.354 0.257 0.252 0.203
# Flails:   0.66  0.427 0.385 0.298 0.394 0.495 0.41
# Diff %:   113.33% 120.57% 115.72% 84.19%  153.22% 196.31% 202.28%
# 
# ## 4 w/o string refs
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.056 0.166 0.34  0.695 1.286 2.465 4.097
# Flails:   0.064 0.186 0.381 0.586 1.863 4.859 8.245
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.565 0.332 0.34  0.347 0.257 0.247 0.205
# Flails:   0.642 0.372 0.381 0.293 0.373 0.486 0.412
# Diff %:   113.78% 111.77% 112.01% 84.35%  144.84% 197.1%  201.25%
# 
# ## 5 w/o variable-length-int encoding (max gain if that's optimised)
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.055 0.2 0.308 0.673 1.219 2.353 4.129
# Flails:   0.062 0.138 0.32  0.519 1.508 4.243 6.425
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.55  0.399 0.308 0.336 0.244 0.235 0.206
# Flails:   0.615 0.276 0.32  0.26  0.302 0.424 0.321
# Diff %:   111.85% 69.2% 104.02% 77.17%  123.67% 180.36% 155.63%
# 
# ## 6 first round of vlint optimisation (direct writing of :uchars)
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.057 0.163 0.322 0.67  1.296 2.38  4.118
# Flails:   0.062 0.173 0.366 0.575 1.763 4.687 7.861
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.569 0.325 0.322 0.335 0.259 0.238 0.206
# Flails:   0.617 0.347 0.366 0.288 0.353 0.469 0.393
# Diff %:   108.42% 106.54% 113.76% 85.82%  136.0%  196.98% 190.87%
# 
# ## 7 second round of vlint optimisation (direct call to f_write_vlint)
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.056 0.177 0.34  0.758 1.326 2.372 3.802
# Flails:   0.062 0.165 0.342 0.628 1.659 4.274 7.075
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.562 0.354 0.34  0.379 0.265 0.237 0.19
# Flails:   0.625 0.331 0.342 0.314 0.332 0.427 0.354
# Diff %:   111.25% 93.43%  100.64% 82.75%  125.11% 180.17% 186.08%
# 
# ## 8 f_write_string
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.055 0.164 0.319 0.661 1.217 2.358 3.944
# Flails:   0.079 0.175 0.331 0.551 1.704 4.23  7.12
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.551 0.328 0.319 0.33  0.243 0.236 0.197
# Flails:   0.792 0.351 0.331 0.276 0.341 0.423 0.356
# Diff %:   143.89% 106.9%  103.81% 83.46%  140.01% 179.44% 180.54%
# 
# ## 9 f_write_uchar
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.059 0.167 0.354 0.647 1.281 2.477 3.831
# Flails:   0.061 0.147 0.326 0.543 1.602 4.118 6.722
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.592 0.334 0.354 0.324 0.256 0.248 0.192
# Flails:   0.615 0.293 0.326 0.271 0.32  0.412 0.336
# Diff %:   103.89% 87.67%  92.03%  83.88%  125.01% 166.23% 175.44%
# 
# ## 10 f_write_double
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.054 0.163 0.325 0.67  1.376 2.412 3.855
# Flails:   0.061 0.143 0.331 0.524 1.568 4.005 6.672
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.543 0.327 0.325 0.335 0.275 0.241 0.193
# Flails:   0.605 0.286 0.331 0.262 0.314 0.4 0.334
# Diff %:   111.5%  87.61%  101.94% 78.23%  113.94% 166.0%  173.07%
# 
# ## 11 don't reference dates
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.055 0.188 0.349 0.661 1.214 2.309 3.902
# Flails:   0.062 0.159 0.317 0.431 1.443 3.678 5.864
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.545 0.376 0.349 0.33  0.243 0.231 0.195
# Flails:   0.62  0.317 0.317 0.215 0.289 0.368 0.293
# Diff %:   113.78% 84.34%  90.79%  65.21%  118.88% 159.29% 150.3%
# 
# ## 12 don't reference strings
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.056 0.165 0.332 0.662 1.219 2.373 3.853
# Flails:   0.058 0.13  0.282 0.485 1.362 3.395 5.659
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.559 0.33  0.332 0.331 0.244 0.237 0.193
# Flails:   0.577 0.261 0.282 0.243 0.272 0.339 0.283
# Diff %:   103.2%  79.06%  84.83%  73.28%  111.77% 143.05% 146.88%
# 
# ## 13 optimised objects context
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.055 0.165 0.309 0.662 1.269 2.395 3.795
# Flails:   0.072 0.127 0.291 0.407 1.107 2.5 3.071
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.549 0.331 0.309 0.331 0.254 0.24  0.19
# Flails:   0.722 0.254 0.291 0.203 0.221 0.25  0.154
# Diff %:   131.5%  76.98%  94.17%  61.47%  87.25%  104.4%  80.93%
# 
# ## 14 String references back in
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.051 0.166 0.321 0.742 1.316 2.726 3.803
# Flails:   0.06  0.13  0.282 0.436 1.216 2.808 3.203
# --------------------------
# Fractional results (ms):
# Objects:  100 500 1000  2000  5000  10000 20000
# RubyAMF:  0.51  0.331 0.321 0.371 0.263 0.273 0.19
# Flails:   0.598 0.261 0.282 0.218 0.243 0.281 0.16
# Diff %:   117.25% 78.73%  87.89%  58.81%  92.44%  103.0%  84.23%
