module Swaggard
  class Api

    attr_reader :nickname
    attr_accessor :path, :parameters, :description, :http_method, :response_class, :summary, :notes, :error_responses

    def initialize(yard_object, controller_class, routes)
      @description = yard_object.docstring.lines.first
      @parameters  = []

      @notes = yard_object.docstring.lines[1..-1]

      yard_object.tags.each do |tag|
        value = tag.text

        case tag.tag_name
          # when "path"
          #   parse_path(value)
        when "parameter"
          @parameters << parse_parameter(value)
        when "parameter_list"
          @parameters << parse_parameter_list(value)
        when "response_class"
          @response_class = value
          # when "notes"
          #   @notes = value.gsub("\n", "<br\>")
        end
      end

      if controller_class
        route = (routes[controller_class.controller_path] || {})[yard_object.name.to_s]
        if route
          @http_method = route[:verb]
          @path = route[:path]

          route[:path_params].each do |path_param|
            @parameters << {
              "paramType"     => "path",
              "name"          => path_param.to_s,
              "description"   => "Scope response to #{path_param}",
              "dataType"      => "string",
              "required"      => true,
              "allowMultiple" => false
            }
          end
        end
      end

      @parameters.sort_by { |parameter| parameter["name"] }
      @parameters << add_format_parameters
    end

    def nickname
      @nickname ||= "#{http_method}".camelize
    end

    def operation
      produces = Swaggard.configuration.api_formats.map { |format| "application/#{format}" }

      {
        "httpMethod"     => http_method,
        "nickname"       => path[1..-1].gsub(/[^a-zA-Z\d:]/, '-').squeeze("-") + http_method.downcase,
        "responseClass"  => response_class || "void",
        "produces"       => produces,
        "parameters"     => parameters,
        "summary"        => summary || description,
        "description"    => '111111',
        "notes"          => 'notes',
        "errorResponses" => error_responses,
      }.merge(response_model)
    end

    def to_h
      {
        "path"        => path,
        "description" => description,
        "operations"  => [operation],
      }
    end

    def array_response?
      response_class =~ /Array/
    end

    def response_model
      if array_response?
        {
          "type"           =>  'array',
          'items'          => {
            '$ref'        => "ProductSerializer"
          }
        }
      else
        { 'responseMessages' => response_messages }
      end
    end

    def response_messages
      messages = []
      if response_class
        messages << {
          "code" => 200,
          "message" => "Ok",
          "responseModel" => response_class
        }
      end

      messages
    end

    def valid?
      path.present?
    end

    private

    ##
    # Example: [Array]     status            Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
    # Example: [Array]     status(required)  Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
    # Example: [Integer]   media[media_type_id]                          ID of the desired media type.
    def parse_parameter(string)
      data_type, name, required, description = string.match(/\A\[(\w*)\]\s*([\w\[\]]*)(\(required\))?\s*(.*)\Z/).captures
      allow_multiple = name.gsub!("[]", "")

      {
        "paramType"     => "query",
        "name"          => name,
        "description"   => description,
        "dataType"      => data_type.downcase,
        "required"      => required.present?,
        "allowMultiple" => allow_multiple.present?
      }
    end

    ##
    # Example: [String]    sort_order  Orders ownerships by fields. (e.g. sort_order=created_at)
    #          [List]      id
    #          [List]      begin_at
    #          [List]      end_at
    #          [List]      created_at
    def parse_parameter_list(string)
      data_type, name, required, description, set_string = string.match(/\A\[(\w*)\]\s*(\w*)(\(required\))?\s*(.*)\n([.\s\S]*)\Z/).captures

      list_values = set_string.split("[List]").map(&:strip).reject { |string| string.empty? }

      {
        "paramType"       => "query",
        "name"            => name,
        "description"     => description,
        "dataType"        => data_type.downcase,
        "required"        => required.present?,
        "allowMultiple"   => false,
        "allowableValues" => {"valueType" => 'LIST', "values" => list_values}
      }
    end

    def add_format_parameters
      formats = Swaggard.configuration.api_formats.map(&:upcase)
      formats = formats.to_sentence(two_words_connector: ' or ', last_word_connector: ', or ')

      description = "Response format either: #{formats}"
      @add_format_parameters ||= {
        "paramType"       => "path",
        "name"            => "format_type",
        "description"     => description,
        "dataType"        => "string",
        "required"        => true,
        "allowMultiple"   => false,
        "allowableValues" => { "valueType" => "LIST", "values" => Swaggard.configuration.api_formats }
      }
    end
  end
end