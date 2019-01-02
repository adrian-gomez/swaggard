require_relative '../swagger/operation'
require_relative '../swagger/tag'

module Swaggard
  module Parsers
    class Controller

      def run(yard_objects)
        tag = nil
        operations = {}

        yard_objects.each do |yard_object|
          if yard_object.type == :class
            tag = Swagger::Tag.new(yard_object)
          elsif tag && yard_object.type == :method
            name = yard_object.name
            operations[name.to_s] = yard_object
          end
        end

        return tag, operations
      end

    end
  end
end
