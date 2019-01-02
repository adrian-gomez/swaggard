require 'json'
require 'yard'

require 'swaggard/api_definition'
require 'swaggard/configuration'
require 'swaggard/engine'

require 'swaggard/parsers/controller'
require 'swaggard/parsers/models'
require 'swaggard/parsers/routes'

module Swaggard

  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Swaggard::Configuration.new
    end

    # Register some custom yard tags
    def register_custom_yard_tags!
      ::YARD::Tags::Library.define_tag('Controller\'s tag', :tag)
      ::YARD::Tags::Library.define_tag('Operation id', :operation_id)
      ::YARD::Tags::Library.define_tag('Query parameter', :query_parameter)
      ::YARD::Tags::Library.define_tag('Form parameter', :form_parameter)
      ::YARD::Tags::Library.define_tag('Body required', :body_required)
      ::YARD::Tags::Library.define_tag('Body description', :body_description)
      ::YARD::Tags::Library.define_tag('Body title', :body_title)
      ::YARD::Tags::Library.define_tag('Body definition', :body_definition)
      ::YARD::Tags::Library.define_tag('Body parameter', :body_parameter)
      ::YARD::Tags::Library.define_tag('Parameter list', :parameter_list)
      ::YARD::Tags::Library.define_tag('Response class', :response_class)
      ::YARD::Tags::Library.define_tag('Response root', :response_root)
      ::YARD::Tags::Library.define_tag('Response status', :response_status)
      ::YARD::Tags::Library.define_tag('Response description', :response_description)
      ::YARD::Tags::Library.define_tag('Response example', :response_example)
      ::YARD::Tags::Library.define_tag('Response header', :response_header)
    end

    def get_doc(host = nil)
      load!

      doc = @api.to_doc

      doc['host'] = host if doc['host'].blank? && host

      doc
    end

    private

    def load!
      @api = Swaggard::ApiDefinition.new

      parse_models
      build_operations
    end

    def build_operation(path, verb, route)
      controller_name = route[:controller]
      action_name = route[:action]

      return unless controllers[controller_name]

      controller_tag = controllers[controller_name][:tag]

      return unless controller_tag

      return unless controllers[controller_name][:operations]

      return unless controllers[controller_name][:operations][action_name]

      operation_yard_object = controllers[controller_name][:operations][action_name]

      return unless operation_yard_object

      operation = Swagger::Operation.new(operation_yard_object, controller_tag, path, verb, route[:path_params])

      return unless operation.valid?
      return if Swaggard.configuration.ignore_undocumented_paths && operation.empty?

      return controller_tag, operation
    end

    def build_operations
      routes.each do |path, verbs|
        verbs.each do |verb, route_options|
          tag, operation = build_operation(path, verb, route_options)

          next unless tag

          @api.add_tag(tag)
          @api.add_operation(operation)
        end
      end
    end

    def controllers
      return @controllers if @controllers

      parser = Parsers::Controller.new

      @controllers = {}
      Dir[configuration.controllers_path].each do |file|
        yard_objects = get_yard_objects(file)

        tag, operations = parser.run(yard_objects)

        next unless tag

        @controllers[tag.controller_class.controller_path] ||= { tag: tag, operations: operations }
      end

      @controllers
    end

    def routes
      return @routes if @routes

      parser = Parsers::Routes.new
      @routes = parser.run(configuration.routes)
    end

    def parse_models
      parser = Parsers::Models.new

      definitions =[]
      configuration.models_paths.each do |path|
        Dir[path].each do |file|
          yard_objects = get_yard_objects(file)

          definitions.concat(parser.run(yard_objects))
        end

        @api.definitions = definitions
      end
    end

    def get_yard_objects(file)
      ::YARD.parse(file)
      yard_objects = ::YARD::Registry.all
      ::YARD::Registry.clear

      yard_objects
    end

  end
end
