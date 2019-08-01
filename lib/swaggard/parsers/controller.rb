require_relative '../swagger/operation'
require_relative '../swagger/tag'

module Swaggard
  module Parsers
    class Controller
      def run(yard_objects)
        tags = nil
        operations = {}

        yard_objects.each do |yard_object|
          if yard_object.type == :class
            tags = get_tags(yard_object)
          elsif tags && yard_object.type == :method
            name = yard_object.name
            operations[name.to_s] = yard_object
          end
        end

        return tags, operations
      end

      private

      def get_tags(yard_object)
        tags = yard_object.tags.select { |tag| tag.tag_name == 'tag' }

        tags.map { |tag| Swagger::Tag.new(yard_object, tag) }
      end
    end
  end
end
