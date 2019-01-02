module Swaggard
  module Swagger
    class ResponseHeader
      attr_reader :name

      def initialize(string)
        parse(string)
      end

      def to_doc
        {
          'description' => @description,
          'type'        => @type,
        }
      end

      private

      # Example: [Array]     status            Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
      # Example: [Array]!    status  Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
      # Example: [Integer]   media[media_type_id]                          ID of the desired media type.
      def parse(string)
        data_type, name, options_and_description = string.match(/\A\[(\S*)\]\s*([\w\-\[\]]*)\s*(.*)\Z/).captures
        allow_multiple = name.gsub!('[]', '')

        options, description = options_and_description.match(/\A(\[.*\])?(.*)\Z/).captures
        options = options ? options.gsub(/\[?\]?\s?/, '').split(',') : []

        @name = name
        @description = description
        @type = data_type
        @allow_multiple = allow_multiple.present?
        @options = options
      end
    end
  end
end
