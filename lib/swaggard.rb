require 'json'
require 'yard'

require 'swaggard/api_definition'
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

    def generate!(controller_path, models_path, routes)
      register_custom_yard_tags!
      @controller_path = controller_path
      @models_path = models_path
      @routes = parse_routes(routes)

      load!
    end

    def get_doc
      load!

      @api.to_doc
    end

    private

    def load!
      @api = Swaggard::ApiDefinition.new

      parse_models
      parse_controllers
    end

    # Register some custom yard tags
    def register_custom_yard_tags!
      ::YARD::Tags::Library.define_tag('Query parameter', :query_parameter)
      ::YARD::Tags::Library.define_tag('Form parameter',  :form_parameter)
      ::YARD::Tags::Library.define_tag('Body parameter',  :body_parameter)
      ::YARD::Tags::Library.define_tag('Parameter list',  :parameter_list)
      ::YARD::Tags::Library.define_tag('Response class',  :response_class)
    end

    def parse_controllers
      parser = ControllersParser.new

      Dir[@controller_path].each do |file|
        yard_objects = get_yard_objects(file)

        tag, operations = parser.run(yard_objects, @routes)

        next unless tag

        @api.add_tag(tag)
        operations.each { |operation| @api.add_operation(operation) }
      end
    end

    def parse_routes(routes)
      parser = Swaggard::RoutesParser.new
      @routes = parser.run(routes)
    end

    def parse_models
      parser = ModelsParser.new

      definitions =[]
      Dir[@models_path].each do |file|
        yard_objects = get_yard_objects(file)

        definitions.concat(parser.run(yard_objects))
      end

      @api.definitions = definitions
    end

    def get_yard_objects(file)
      ::YARD.parse(file)
      yard_objects = ::YARD::Registry.all
      ::YARD::Registry.clear

      yard_objects
    end

  end
end
