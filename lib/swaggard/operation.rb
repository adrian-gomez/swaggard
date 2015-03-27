require_relative 'parameters/body'
require_relative 'parameters/form'
require_relative 'parameters/path'
require_relative 'parameters/list'

require_relative 'query_parameter'
require_relative 'response'

module Swaggard
  class Operation

    attr_reader :nickname
    attr_accessor :path, :parameters, :description, :http_method, :summary, :notes,
                  :error_responses, :tag

    def initialize(yard_object, tag, routes)
      @name = yard_object.name
      @tag = tag
      @summary = yard_object.docstring.lines.first || ''
      @parameters  = []
      @responses = []
      @description = (yard_object.docstring.lines[1..-1] || []).join("\n")
      @formats = Swaggard.configuration.api_formats

      yard_object.tags.each do |yard_tag|
        value = yard_tag.text

        case yard_tag.tag_name
        when 'query_parameter'
          @parameters << Parameters::Query.new(value)
        when 'form_parameter'
          @parameters << Parameters::Form.new(value)
        when 'body_parameter'
          body_parameter.add_property(value)
        when 'parameter_list'
          @parameters << Parameters::List.new(value)
        when 'response_class'
          @responses << Response.new(200, value)
        end
      end

      build_path_parameters(routes)

      @parameters.sort_by { |parameter| parameter.name }
    end

    def valid?
      @path.present?
    end

    def to_doc
      produces = @formats.map { |format| "application/#{format}" }
      consumes = @formats.map { |format| "application/#{format}" }

      {
        "tags"           => [@tag.name],
        "summary"        => @summary,
        'description'    => @description,
        'operationId'    => @name,
        'consumes'       => consumes,
        "produces"       => produces,
        "parameters"     => @parameters.map(&:to_doc),
        'responses'      => Hash[@responses.map { |response| [response.status_code, response.to_doc] }]
      }
    end

    def definitions
      @body_parameter ? [@body_parameter.definition] : []
    end

    private

    def body_parameter
      return @body_parameter if @body_parameter

      @body_parameter = Parameters::Body.new("#{@tag.controller_class.to_s}.#{@name}")
      @parameters << @body_parameter

      @body_parameter
    end

    def build_path_parameters(routes)
      return unless @tag.controller_class

      route = (routes[@tag.controller_class.controller_path] || {})[@name.to_s]

      return unless route

      @http_method = route[:verb]
      @path = route[:path]

      route[:path_params].each { |path_param| @parameters << Parameters::Path.new(path_param) }
    end

  end
end