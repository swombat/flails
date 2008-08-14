require 'util/string'
require 'initializer' unless defined? ::Rails::Initializer 
require 'dispatcher' unless defined? ::ActionController::Dispatcher

module Flails
  def self.autoload
    RAILS_DEFAULT_LOGGER.debug "Flails autoload hook activated"
    
    load File.expand_path(RAILS_ROOT) + '/config/rubyamf_config.rb'
    load File.expand_path(RAILS_ROOT) + '/config/rubyamf_class_mappings.rb'
    load File.expand_path(RAILS_ROOT) + '/config/rubyamf_parameter_mappings.rb'

    ::Flails::IO::Util::ClassDefinition.class_name_mappings = { ::Flails::IO::Util::AcknowledgeMessage.to_s => "flex.messaging.messages.AcknowledgeMessage" }
  end
end

class Rails::Initializer #:nodoc:
  # Make sure it gets loaded in the console, tests, and migrations
  def after_initialize_with_flails_autoload 
    after_initialize_without_flails_autoload
    Flails.autoload
  end
  alias_method_chain :after_initialize, :flails_autoload 
end
 
Dispatcher.to_prepare(:flails_autoload) do
  # Make sure it gets loaded in the app
  Flails.autoload
end