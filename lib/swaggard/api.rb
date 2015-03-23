module Swaggard
  class Api

    attr_reader :nickname
    attr_accessor :path, :parameters, :description, :http_method, :response_class, :summary, :notes, :error_responses

    def initialize(yard_object, controller_class, routes)
      @description = yard_object.docstring.lines.first
      @parameters  = []

      @notes = yard_object.docstring.lines[1..-1]

      # p @description

      yard_object.tags.each do |tag|
        value = tag.text

        case tag.tag_name
          # when "path"
          #   parse_path(value)
        when "parameter"
          @parameters << parse_parameter(value)
        when "parameter_list"
          @parameters << parse_parameter_list(value)
          # when "summary"
          #   @summary = value
          # when "notes"
          #   @notes = value.gsub("\n", "<br\>")
        end
      end

      if controller_class
        # p controller_class.controller_path
        # p routes[controller_class.controller_path]
        route = (routes[controller_class.controller_path] || {})[yard_object.name.to_s]
        if route
          # parse_path("[#{route[:verb]}] #{route[:path]}")
          @http_method = route[:verb]
          @path = route[:path]

          # path_params = @path.scan(/\{([^\}]+)\}/).flatten.reject { |value| value == "format_type" }

          route[:path_params].each do |path_param|
            @parameters << {
              "paramType"     => "path",
              "name"          => path_param,
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
      {
        "httpMethod"     => http_method,
        "nickname"       => path[1..-1].gsub(/[^a-zA-Z\d:]/, '-').squeeze("-") + http_method.downcase,
        "responseClass"  => response_class || "void",
        "produces"       => Swaggard.api_formats.map { |format| "application/#{format}" },
        "parameters"     => parameters,
        "summary"        => summary || description,
        "notes"          => notes,
        "errorResponses" => error_responses,
        "type"           =>  'name',
        'responseMessages' => [
          {
            "code" => 200,
            "message" => "Ok",
            "responseModel" => "controllers.Ping"
          }
        ]
      }
    end

    def to_h
      {
        "path"        => path,
        "description" => description,
        "operations"  => [operation],
      }
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
      formats = Swaggard.api_formats.map(&:upcase).to_sentence(two_words_connector: ' or ',
                                                               last_word_connector: ', or ')

      description = "Response format either: #{formats}"
      @add_format_parameters ||= {
        "paramType"       => "path",
        "name"            => "format_type",
        "description"     => description,
        "dataType"        => "string",
        "required"        => true,
        "allowMultiple"   => false,
        "allowableValues" => { "valueType" => "LIST", "values" => Swaggard.api_formats }
      }
    end
  end
end