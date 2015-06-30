module Swaggard
  module Swagger
    class Response

      PRIMITIVE_TYPES = %w[number string integer float boolean]

      attr_reader :status_code

      def initialize(status_code, value)
        @status_code = status_code
        parse(value)
      end

      def to_doc
        {
          'description' => '',
          'schema'      => response_model
        }
      end

      private

      def parse(value)
        @is_array_response = value =~ /Array/
        @response_class = if @is_array_response
                            value.match(/^Array<(.*)>$/)[1]
                          else
                            value
                          end
      end

      def response_model
        if @is_array_response
          {
            'type'  => 'array',
            'items' => response_class_type
          }
        else
          response_class_type
        end
      end

      def response_class_type
        if PRIMITIVE_TYPES.include?(@response_class)
          { 'type' => @response_class }
        else
          { '$ref' => "#/definitions/#@response_class" }
        end
      end

    end
  end
end