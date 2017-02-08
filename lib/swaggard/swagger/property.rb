require_relative 'type'

module Swaggard
  module Swagger
    class Property

      attr_reader :id, :type, :description

      def initialize(yard_object)
        @id = yard_object.name
        @type = Type.new(yard_object.types)
        @description = yard_object.text
      end

      def to_doc
        result = @type.to_doc
        result['description'] = @description if @description
        result
      end

    end
  end
end
