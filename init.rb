#$:.unshift(File.expand_path(RAILS_ROOT) + '/vendor/plugins/rubyamf/')

#utils must be first
require 'util/string'
require 'util/vo_helper'
require 'util/action_controller'
require 'app/fault_object'
require 'app/rails_gateway'
require File.expand_path(RAILS_ROOT) + '/config/rubyamf_config' #run the configuration


