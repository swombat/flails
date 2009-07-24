module Flails
  module App
    module Model
      # This module must be included by classes which wish to be rendered through the Flails API.
      # Typically, the Renderable inclusion and mapping directives should be auto-generated
      # from a YAML file... to be included.
      module Renderable
        # Returns a hash of the attributes to be rendered
        def renderable_attributes
          {}
        end
        
        def depth(max_depth, options={})
          Flails::App::Model::RenderableClone.new(self, max_depth, options)
        end
        
        def to_xml(options={})
          options[:indent] ||= 2
          xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
          xml.instruct! unless options[:skip_instruct]
          xml.tag!(xml_key(self.class.name)) do |r|
            self.renderable_attributes.each do |key, value|
              if value.is_a?(Flails::App::Model::Renderable)
                r.tag!(xml_key(key), value.to_xml(:skip_instruct => true))
              elsif value.is_a?(Array)
                r.tag!(xml_key(key).pluralize) do
                  value.each do |sub_value|
                    if (sub_value.is_a?(Flails::App::Model::Renderable))
                      r << sub_value.to_xml(:skip_instruct => true)
                    else
                      r.item(sub_value.to_s)
                    end
                  end
                end
              else
                r.tag!(xml_key(key), value.to_s)
              end
            end
          end
        end
        
        def xml_key(key)
          key.to_s.tableize.singularize.dasherize
        end
        
      end
    end
  end
end