#$:.unshift(File.expand_path(RAILS_ROOT) + '/vendor/plugins/rubyamf/')

#utils must be first
require 'util/string'
require 'util/action_controller'

require File.expand_path(RAILS_ROOT) + '/config/rubyamf_config' #run the configuration


