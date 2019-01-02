require_relative 'type'

module Swaggard
  module Swagger
    class Property

      attr_reader :id, :type, :description

      def initialize(yard_object)
        name = yard_object.name.dup
        options_and_description = yard_object.text&.dup || ''

        options, description = options_and_description.match(/\A(\[.*\])?(.*)\Z/).captures
        options = options ? options.gsub(/\[?\]?\s?/, '').split(',') : []
        description = description.strip
        required = name.gsub!(/^!/, '')

        @id = name
        @type = Type.new(yard_object.types)
        @description = description
        @required = required.present?
        @options = options
      end

      def required?
        @required
      end

      def to_doc
        result = @type.to_doc
        result['description'] = @description if @description.present?
        result['enum'] = @options if @options.present?
        result
      end

    end
  end
end
