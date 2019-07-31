require_relative 'base'
require_relative '../type'

module Swaggard
  module Swagger
    module Parameters
      class Body < Base

        attr_reader :definition

        def initialize(operation_name)
          @in             = 'body'
          @name           = 'body'
          @is_required    = false
          @description    = ''
          @definition     = Definition.new("#{operation_name}_body")
          @definition_id  = @definition.id
        end

        def add_property(string)
          property = Property.new(string)
          @definition.add_property(property)
        end

        def empty?
          @definition.empty?
        end

        def to_doc
          doc = super

          doc.delete('type')
          doc.delete('description')

          doc['schema'] = { '$ref' => "#/definitions/#{@definition_id}" }

          doc
        end

        def description=(description)
          @definition.description = description
        end

        def title=(title)
          @definition.title = title
        end

        def definition=(definition)
          @definition_id = definition
        end

        private


        class Property

          attr_reader :id

          def initialize(string)
            parse(string)
          end

          def required?
            @required
          end

          def to_doc
            result = @type.to_doc
            result['description'] = @description if @description
            result['enum'] = @options if @options.present?
            result
          end

          # Example: [Array]     status            Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
          # Example: [Array]     status(required)  Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
          # Example: [Integer]   media[media_type_id]                          ID of the desired media type.
          def parse(string)
            string.gsub!("\n", ' ')
            data_type, required, name, options_and_description = string.match(/\A\[(\S*)\](!)?\s*([\w\[\]]*)\s*(.*)\Z/).captures
            allow_multiple = name.gsub!('[]', '')
            options, description = options_and_description.match(/\A(\[.*\])?(.*)\Z/).captures
            options = options ? options.gsub(/\[?\]?\s?/, '').split(',') : []

            @id = name
            @description = description if description.present?
            @type = Type.new([data_type])
            @required = required
            @options = options
          end

        end

      end
    end
  end
end
