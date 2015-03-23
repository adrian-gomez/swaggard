require 'json'
require 'yard'

require 'swaggard/controllers_parser'
require 'swaggard/engine'
require 'swaggard/models_parser'
require 'swaggard/routes_parser'

module Swaggard
  class << self
    ##
    # Configuration for Swagger Yard, use like:
    #
    #   Swaggard.configure do |config|
    #     config.swagger_version = "1.1"
    #     config.api_version = "0.1"
    #     config.doc_base_path = "http://swagger.example.com/doc"
    #     config.api_base_path = "http://swagger.example.com/api"
    #   end
    def configure
      yield self
    end

    attr_accessor :doc_base_path, :api_base_path

    attr_writer :swagger_version, :api_version, :api_path, :enable, :api_formats

    def swagger_version
      @swagger_version ||= "1.1"
    end

    def api_version
      @api_version ||= "0.1"
    end

    def api_path
      @api_path ||= ''
    end

    def api_formats
      @api_formats ||= [:xml, :json]
    end

    def enable
      @enable ||= false
    end

    def resource_to_file_path
      @resource_to_file_path ||= {}
    end

    def parse_file(file_path)
      ::YARD.parse(file_path)
      yard_objects = ::YARD::Registry.all
      ::YARD::Registry.clear

      @parser.run(yard_objects, @routes)
    end

    def generate!(controller_path, models_path, routes)
      register_custom_yard_tags!
      @controller_path = controller_path
      @models_path = models_path
      @routes = parse_routes(routes)

      parse_models
      parse_controllers
    end

    def get_api(resource_name)
      parse_controllers

      parse_file(resource_to_file_path[resource_name]).to_h
    end

    def get_listing
      parse_controllers
    end

    private
    ##
    # Register some custom yard tags used by swagger-ui
    def register_custom_yard_tags!
      ::YARD::Tags::Library.define_tag("Api resource", :resource)
      ::YARD::Tags::Library.define_tag("Resource path", :resource_path)
      ::YARD::Tags::Library.define_tag("Api path", :path)
      ::YARD::Tags::Library.define_tag("Parameter", :parameter)
      ::YARD::Tags::Library.define_tag("Parameter list", :parameter_list)
      ::YARD::Tags::Library.define_tag("Status code", :status_code)
      ::YARD::Tags::Library.define_tag("Implementation notes", :notes)
      ::YARD::Tags::Library.define_tag("Response class", :response_class)
      ::YARD::Tags::Library.define_tag("Api Summary", :summary)
    end

    def parse_controllers
      @parser = ControllersParser.new

      Dir[@controller_path].each do |file|
        if api_declaration = parse_file(file)
          resource_to_file_path[api_declaration.resource_name] = file
        end
      end

      @parser.listing.to_h
    end

    def parse_routes(routes)
      parser = Swaggard::RoutesParser.new(routes)
      @routes = parser.run
    end

    def parse_models
      parser = ModelsParser.new

      @models =[]
      Dir[@models_path].each do |file|
        yard_objects = get_yard_objects(file)

        @models.concat(parser.run(yard_objects))
      end

      p @models
    end

    def get_yard_objects(file)
      ::YARD.parse(file)
      yard_objects = ::YARD::Registry.all
      ::YARD::Registry.clear

      yard_objects
    end

  end
end
