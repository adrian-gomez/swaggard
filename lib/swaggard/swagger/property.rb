require_relative 'type'

module Swaggard
  module Swagger
    class Property
      attr_reader :id, :type, :description

      def initialize(name, type, description = '', required = false, options = [])
        @id = name
        @type = type
        @description = description
        @required = required
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
