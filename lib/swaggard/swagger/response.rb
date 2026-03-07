require_relative 'response_header'

module Swaggard
  module Swagger
    class Response

      PRIMITIVE_TYPES = %w[integer long float double string byte binary boolean date date-time password hash]

      attr_writer :status_code, :description

      def initialize(operation_name)
        @operation_name = operation_name
        @response_model = ResponseModel.new
        @headers = []
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

      def add_header(value)
        @headers << ResponseHeader.new(value)
      end

      def description
        @description || Swaggard.configuration.default_response_description
      end

      def to_doc
        { 'description' => description }.tap do |doc|
          schema = if @response_root.present?
                     { '$ref' => "#/components/schemas/#{Swaggard.ref_name(definition.id)}" }
                   elsif @response_model.response_class.present?
                     @response_model.to_doc
                   end

          if schema || @example
            media_type_object = {}
            media_type_object['schema'] = schema if schema
            media_type_object['example'] = example_to_doc if @example
            doc['content'] = Swaggard.configuration.api_formats.each_with_object({}) do |format, content|
              content["application/#{format}"] = media_type_object
            end
          end

          if @headers.any?
            doc['headers'] = Hash[@headers.map { |header| [header.name, header.to_doc] }]
          end
        end
      end

      def example_to_doc
        if File.exist?(@example)
          JSON.parse(File.read(@example))
        else
          { '$ref' => @example }
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
            { '$ref' => "#/components/schemas/#{Swaggard.ref_name(@response_class)}" }
          end
        end
      end
    end
  end
end
