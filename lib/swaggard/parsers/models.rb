require_relative '../swagger/definition'
require_relative 'property'

module Swaggard
  module Parsers
    class Models

      def run(yard_objects)
        definitions = {}

        yard_objects.each do |yard_object|
          definition = parse_yard_object(yard_object)

          definitions[definition.id] = definition if definition
        end

        definitions
      end

      def parse_yard_object(yard_object)
        return unless yard_object.type == :class

        Swagger::Definition.new(yard_object.path, ancestors: yard_object.inheritance_tree.map(&:path)).tap do |definition|
          yard_object.tags.each do |tag|
            case tag.tag_name
            when 'attr'
              property = Swaggard::Parsers::Property.run(tag)
              definition.add_property(property)
            when 'ignore_inherited'
              definition.ignore_inherited = true
            end
          end
        end
      end

    end
  end
end
