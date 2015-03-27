require_relative 'operation'
require_relative 'tag'

module Swaggard
  class ControllersParser

    def run(yard_objects, routes)
      tag = nil
      operations = []
      retain_tag = false

      yard_objects.each do |yard_object|
        if yard_object.type == :class
          tag = Tag.new(yard_object)
          retain_tag = tag.valid?
          break unless retain_tag
        elsif yard_object.type == :method
          operation = Operation.new(yard_object, tag, routes)
          operations << operation if operation.valid?
        else
          break
        end
      end

      return unless retain_tag

      return tag, operations
    end

  end
end