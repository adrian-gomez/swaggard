require 'json'
require 'yard'

require 'swaggard/configuration'
require 'swaggard/controllers_parser'
require 'swaggard/engine'
require 'swaggard/models_parser'
require 'swaggard/routes_parser'

module Swaggard
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Swaggard::Configuration.new
    end

    def resource_to_file_path
      @resource_to_file_path ||= {}
    end

    def parse_file(file_path)
      ::YARD.parse(file_path)
      yard_objects = ::YARD::Registry.all
      ::YARD::Registry.clear

      @parser.run(yard_objects, @routes, @models)
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
      parse_models
      parse_controllers

      parse_file(resource_to_file_path[resource_name]).to_h
    end

    def get_listing
      parse_models
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
        yard_objects = get_yard_objects(file)

        api_declaration = @parser.run(yard_objects, @routes, @models)
        if api_declaration
          resource_to_file_path[api_declaration.file_path] = file
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

      @models
    end

    def get_yard_objects(file)
      ::YARD.parse(file)
      yard_objects = ::YARD::Registry.all
      ::YARD::Registry.clear

      yard_objects
    end

  end
end
