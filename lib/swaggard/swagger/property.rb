require_relative 'type'

module Swaggard
  module Swagger
    class Property
      attr_reader :id, :type, :description

      def initialize(name, type, description = '', required = false, options = [], deprecated = false)
        @id = name
        @type = type
        @description = description
        @required = required
        @options = options
        @deprecated = deprecated
      end

      def required?
        @required
      end

      def deprecated?
        @deprecated
      end

      def to_doc
        result = @type.to_doc
        result['description'] = @description if @description.present?
        result['enum'] = @options if @options.present?
        result['deprecated'] = true if @deprecated
        result
      end
    end
  end
end
