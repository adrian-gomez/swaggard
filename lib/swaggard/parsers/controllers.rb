require_relative '../swagger/operation'
require_relative '../swagger/tag'

module Swaggard
  module Parsers
    class Controllers

      def run(yard_objects, routes)
        tag = nil
        operations = []

        yard_objects.each do |yard_object|
          if yard_object.type == :class
            tag = Swagger::Tag.new(yard_object)
          elsif tag && yard_object.type == :method
            operation = Swagger::Operation.new(yard_object, tag, routes)
            operations << operation if operation.valid?
          end
        end

        return unless operations.any?

        return tag, operations
      end

    end
  end
end
