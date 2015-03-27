require_relative 'definition'
require_relative 'property'

module Swaggard
  class ModelsParser

    def run(yard_objects)
      definitions = []

      yard_objects.each do |yard_object|
        next unless yard_object.type == :class

        definition = Definition.new(yard_object.name)

        yard_object.tags.each do |tag|
          property = Property.new(tag)
          definition.add_property(property)
        end

        definitions << definition
      end

      definitions
    end

  end
end