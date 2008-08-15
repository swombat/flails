class MockFile
  include Flails::App::Model::Renderable
  
  attr_accessor :id, :created_at, :updated_at, :deleted_at, :filename, :size, :parent_id
  
  def initialize
    @id = rand(10000)
    @created_at, @updated_at, @deleted_at = 1.day.ago + rand(10000), 2.days.ago - rand(10000), 3.days.ago + rand(10000)
    @filename = "Some-file-#{rand(10000)}.txt"
    @size = rand(1000000)
    @parent_id = rand(10000)
  end
  
  def attribute_names
    [:id, :created_at, :updated_at, :deleted_at, :filename, :size, :parent_id]
  end
  
  def renderable_attributes
    {
      :id                 => @id        ,
      :created_at         => @created_at,
      :updated_at         => @updated_at,
      :deleted_at         => @deleted_at,
      :filename           => @filename  ,
      :size               => @size      ,
      :parent_id          => @parent_id
    }
  end
end

Flails::IO::Util::ClassDefinition.class_name_mappings = { MockFile.to_s => "MockFile" }
Flails::IO::Util::ClassDefinition.class_name_mappings = { Flails::IO::Util::AcknowledgeMessage.to_s => "flex.messaging.messages.AcknowledgeMessage" }


# Need this because ClassMappings has a dependency on it...
module ActiveRecord
  class StatementInvalid < Exception
  end
end

RubyAMF::Configuration::ClassMappings.register(
  :actionscript => 'MockFile',
  :ruby         => 'MockFile',
  :type         => 'active_record',
  :attributes   => ['id', 'created_at', 'updated_at', 'deleted_at', 'filename', 'size', 'parent_id']
)
