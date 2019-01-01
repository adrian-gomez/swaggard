module Swaggard
  module Swagger
    class Definition

      attr_reader :id

      def initialize(id)
        @id = id
        @properties = []
      end

      def add_property(property)
        @properties << property
      end

      def empty?
        @properties.empty?
      end

      def to_doc
        {
          'type'        => 'object',
          'properties'  => Hash[@properties.map { |property| [property.id, property.to_doc] }],
          'required'    => []
        }
      end

    end
  end
end
