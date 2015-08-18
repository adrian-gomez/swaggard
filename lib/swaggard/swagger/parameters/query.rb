require_relative 'base'

module Swaggard
  module Swagger
    module Parameters
      class Query < Base

        def initialize(string)
          @in = 'query'
          parse(string)
        end

        def to_doc
          doc = super

          doc.merge!('enum' => @options) if @options.any?

          doc
        end

        private

        # Example: [Array]     status            Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
        # Example: [Array]     status(required)  Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
        # Example: [Integer]   media[media_type_id]                          ID of the desired media type.
        def parse(string)
          data_type, name, required, options_and_description = string.match(/\A\[(\w*)\]\s*([\w\[\]]*)(\(required\))?\s*(.*)\Z/).captures
          allow_multiple = name.gsub!('[]', '')

          options, description = options_and_description.match(/\A(\[.*\])?(.*)\Z/).captures
          options = options ? options.gsub(/\[?\]?\s?/, '').split(',') : []

          @name = name
          @description = description
          @data_type = data_type.downcase
          @is_required = required.present?
          @allow_multiple = allow_multiple.present?
          @options = options
        end

      end
    end
  end
end