require_relative 'base'
require_relative '../type'

module Swaggard
  module Swagger
    module Parameters
      class Body < Base

        attr_reader :definition

        def initialize(operation_name)
          @in           = 'body'
          @name         = 'body'
          @description  = ''
          @definition   = Definition.new("#{operation_name}_body")
        end

        def add_property(string)
          property = Property.new(string)
          @definition.add_property(property)
        end

        def to_doc
          doc = super

          doc.delete('type')

          doc['required'] = false
          doc['schema'] = { '$ref' => "#/definitions/#{@definition.id}" }

          doc
        end

        private


        class Property

          attr_reader :id

          def initialize(string)
            parse(string)
          end

          def to_doc
            result = @type.to_doc
            result['description'] = @description if @description
            result
          end

          # Example: [Array]     status            Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
          # Example: [Array]     status(required)  Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
          # Example: [Integer]   media[media_type_id]                          ID of the desired media type.
          def parse(string)
            data_type, name, description = string.split

            data_type.gsub!('[', '').gsub!(']', '')

            @id = name
            @description = description
            @type = Type.new([data_type])
          end

        end

      end
    end
  end
end