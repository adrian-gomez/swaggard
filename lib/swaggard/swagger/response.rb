module Swaggard
  module Swagger
    class Response

      PRIMITIVE_TYPES = %w[integer long float double string byte binary boolean date date-time password hash]

      attr_writer :status_code, :description

      def initialize(operation_name)
        @operation_name = operation_name
        @response_model = ResponseModel.new
      end

      def definition
        return unless @response_root.present?

        @definition ||= Definition.new("#{@operation_name}_response").tap do |definition|
          definition.add_property(@response_model)
        end
      end

      def status_code
        @status_code || Swaggard.configuration.default_response_status_code
      end

      def response_class=(value)
        @response_model.parse(value)
      end

      def response_root=(root)
        @response_root = root
        @response_model.id = root
      end

      def add_example(value)
        @example = value
      end

      def description
        @description || Swaggard.configuration.default_response_description
      end

      def to_doc
        { 'description' => description }.tap do |doc|
          schema = if @response_root.present?
                     { '$ref' => "#/definitions/#{definition.id}" }
                   elsif @response_model.response_class.present?
                     @response_model.to_doc
                   end

          doc.merge!('schema' => schema) if schema
          doc.merge!('examples' => example_to_doc) if @example
        end
      end

      def example_to_doc
        Swaggard.configuration.api_formats.inject({}) do |examples, format|
          examples.merge!("application/#{format}" => { '$ref' => @example })

          examples
        end
      end

      private

      class ResponseModel
        attr_accessor :id, :response_class

        def parse(value)
          @is_array_response = value =~ /Array/
          @response_class = if @is_array_response
                              value.match(/^Array<(.*)>$/)[1]
                            else
                              value
                            end
        end

        def to_doc
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
end
