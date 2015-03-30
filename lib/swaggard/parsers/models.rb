require_relative '../swagger/definition'
require_relative '../swagger/property'

module Swaggard
  module Parsers
    class Models

      def run(yard_objects)
        definitions = []

        yard_objects.each do |yard_object|
          next unless yard_object.type == :class

          definition = Swagger::Definition.new(yard_object.name)

          yard_object.tags.each do |tag|
            property = Swagger::Property.new(tag)
            definition.add_property(property)
          end

          definitions << definition
        end

        definitions
      end

    end
  end
end