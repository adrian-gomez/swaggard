require_relative 'base'
require_relative '../../parsers/type'

module Swaggard
  module Swagger
    module Parameters
      class Query < Base
        def initialize(string)
          @in = 'query'
          parse(string)
        end

        def to_doc
          schema = @type.to_doc

          if @options.present? && @type.is_array?
            schema['items']['enum'] = @options
          elsif @options.present?
            schema['enum'] = @options
          end

          {
            'name'        => @name,
            'in'          => @in,
            'required'    => @is_required,
            'description' => description,
            'schema'      => schema
          }
        end

        private

        # Example: [Array]     status            Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
        # Example: [Array]     status!           Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
        # Example: [Integer]   media[media_type_id]                          ID of the desired media type.
        def parse(string)
          data_type, required, name, options_and_description = string.match(/\A\[(\S*)\](!)?\s*([\w\[\]]*)\s*(.*)\Z/).captures

          options, description = options_and_description.match(/\A(\[.*\])?(.*)\Z/).captures
          options = options ? options.gsub(/\[?\]?\s?/, '').split(',') : []

          @name = name
          @description = description
          @type = Parsers::Type.run(data_type)
          @is_required = required.present?
          @options = options
        end
      end
    end
  end
end
