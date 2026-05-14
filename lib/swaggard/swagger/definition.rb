module Swaggard
  module Swagger
    class Definition

      attr_reader :id
      attr_writer :description, :title, :ignore_inherited

      def initialize(id, ancestors: [], collection: false)
        @id = id
        @title = ''
        @properties = []
        @description = ''
        @ancestors = ancestors
        @ignore_inherited = false
        @collection = collection
      end

      def add_property(property)
        @properties << property
      end

      def empty?
        @properties.empty?
      end

      def properties(definitions)
        inherited_properties(definitions)
          .concat(@properties)
          .uniq { |property| property.id }
      end

      def inherited_properties(definitions)
        return [] if @ignore_inherited

        @ancestors.flat_map do |ancestor|
          definition = definitions[ancestor]

          next unless definition && definition.id != id

          definition.properties(definitions)
        end.compact
      end

      def to_doc(definitions)
        all_properties = properties(definitions)
        properties_hash = Hash[all_properties.map { |property| [property.id, property.to_doc] }]
        required_properties = all_properties.select(&:required?).map(&:id)

        if @collection
          items = { 'type' => 'object', 'properties' => properties_hash }
          items['required'] = required_properties if required_properties.any?

          {}.tap do |doc|
            doc['title'] = @title if @title.present?
            doc['type'] = 'array'
            doc['description'] = @description if @description.present?
            doc['items'] = items
          end
        else
          {}.tap do |doc|
            doc['title'] = @title if @title.present?
            doc['type']  = 'object'

            doc['description'] = @description if @description.present?

            doc['properties'] = properties_hash
            doc['required'] = required_properties if required_properties.any?
          end
        end
      end

    end
  end
end
