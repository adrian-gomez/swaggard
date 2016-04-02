module Swaggard
  module Swagger
    class Tag

      attr_accessor :name, :description

      attr_reader :controller_class

      def initialize(yard_object)
        @yard_name = yard_object.name

        controller_name = "#{yard_object.namespace}::#{yard_object.name}"
        controller_name.prepend("#{Swaggard.configuration.module_name}::") if !Swaggard.configuration.module_name.blank?

        @controller_class = controller_name.constantize

        tag = yard_object.tags.find { |tag| tag.tag_name == 'tag' }

        @name =  tag ? tag.text : "#{@controller_class.controller_path}"
        @description = yard_object.docstring || ''
      end

      def to_doc
        {
          'name'        => @name,
          'description' => @description
        }
      end

    end
  end
end