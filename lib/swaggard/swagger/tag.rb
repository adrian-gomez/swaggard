module Swaggard
  module Swagger
    class Tag
      attr_accessor :name, :description

      attr_reader :controller_class, :controller_name, :route

      def initialize(yard_object, tag)
        controller_name = "#{yard_object.namespace}::#{yard_object.name}"

        @yard_name = yard_object.name
        @controller_class = controller_name.constantize
        @controller_name = controller_class.controller_path

        @name =  tag ? tag.text : "#{@controller_class.controller_path}"
        @name, @route = @name.split(' ')

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
