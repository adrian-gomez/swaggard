require_relative 'parameters/body'
require_relative 'parameters/form'
require_relative 'parameters/list'
require_relative 'parameters/path'
require_relative 'parameters/query'

require_relative 'response'

module Swaggard
  module Swagger
    class Operation
      attr_reader :nickname
      attr_accessor :path, :parameters, :description, :http_method, :summary, :notes,
                    :error_responses, :tag

      def initialize(yard_object, tag, path, verb, path_params)
        @name = yard_object.name
        @tag = tag
        @summary = (yard_object.docstring.lines.first || '').chomp
        @parameters  = []
        @responses = []

        @description = (yard_object.docstring.lines[1..-1] || []).map(&:chomp).reject(&:empty?).compact.join("\n")
        @formats = Swaggard.configuration.api_formats
        @http_method = verb
        @path = path

        build_path_parameters(path_params)

        yard_object.tags.each do |yard_tag|
          value = yard_tag.text

          case yard_tag.tag_name
          when 'operation_id'
            @operation_id = "#{@tag.name}.#{value}"
          when 'query_parameter'
            @parameters << Parameters::Query.new(value)
          when 'form_parameter'
            @parameters << Parameters::Form.new(value)
          when 'body_required'
            body_parameter.is_required = true
          when 'body_description'
            body_parameter.description = value
          when 'body_title'
            body_parameter.title = value
          when 'body_definition'
            body_parameter.definition = value
          when 'body_parameter'
            body_parameter.add_property(value)
          when 'parameter_list'
            @parameters << Parameters::List.new(value)
          when 'response_class'
            success_response.response_class = value
          when 'response_status'
            success_response.status_code = value
          when 'response_root'
            success_response.response_root = value
          when 'response_description'
            success_response.description = value
          when 'response_example'
            success_response.add_example(value)
          when 'response_header'
            success_response.add_header(value)
          end
        end

        @parameters.sort_by { |parameter| parameter.name }

        @responses << success_response
      end

      def valid?
        @path.present?
      end

      def empty?
        @summary.blank? && @description.blank?
      end

      def to_doc
        {
          'tags'           => [@tag.name],
          'operationId'    => @operation_id || "#{@path}/#{@name}".parameterize,
          'summary'        => @summary,
          'description'    => @description,
          'produces'       => @formats.map { |format| "application/#{format}" },
        }.tap do |doc|
          doc['consumes'] = @formats.map { |format| "application/#{format}" } if @body_parameter
          doc['parameters'] = @parameters.map(&:to_doc)
          doc['responses'] = Hash[@responses.map { |response| [response.status_code, response.to_doc] }]
        end
      end

      def definitions
        @responses.map(&:definition).compact.tap do |definitions|
          definitions << @body_parameter.definition if @body_parameter
        end
      end

      private

      def success_response
        @success_response ||= Response.new("#{@tag.controller_class.to_s}.#{@name}")
      end

      def body_parameter
        return @body_parameter if @body_parameter

        @body_parameter = Parameters::Body.new("#{@tag.controller_class.to_s}.#{@name}")
        @parameters << @body_parameter

        @body_parameter
      end

      def build_path_parameters(path_params)
        return unless @tag.controller_class

        path_params.each { |path_param| @parameters << Parameters::Path.new(self, path_param) }
      end
    end
  end
end
