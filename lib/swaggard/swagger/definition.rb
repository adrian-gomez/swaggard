module Swaggard
  module Swagger
    class Definition

      attr_reader :id
      attr_writer :description, :title

      def initialize(id)
        @id = id
        @title = ''
        @properties = []
        @description = ''
      end

      def add_property(property)
        @properties << property
      end

      def empty?
        @properties.empty?
      end

      def to_doc
        {}.tap do |doc|
          doc['title'] = @title if @title.present?
          doc['type']  = 'object'

          doc['description'] = @description if @description.present?

          doc['properties'] =  Hash[@properties.map { |property| [property.id, property.to_doc] }]
          required_properties = @properties.select(&:required?).map(&:id)
          doc['required'] = required_properties if required_properties.any?
        end

      end

    end
  end
end
