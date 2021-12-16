module Swaggard
  module Swagger
    class Definition

      attr_reader :id
      attr_writer :description, :title, :ignore_inherited

      def initialize(id, ancestors: [])
        @id = id
        @title = ''
        @properties = []
        @description = ''
        @ancestors = ancestors
        @ignore_inherited = false
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
        {}.tap do |doc|
          doc['title'] = @title if @title.present?
          doc['type']  = 'object'

          doc['description'] = @description if @description.present?

          all_properties = properties(definitions)

          doc['properties'] =  Hash[all_properties.map { |property| [property.id, property.to_doc] }]
          required_properties = all_properties.select(&:required?).map(&:id)
          doc['required'] = required_properties if required_properties.any?
        end

      end

    end
  end
end
