require_relative 'path'

module Swaggard
  class ApiDefinition

    attr_accessor :definitions

    def initialize
      @paths        = {}
      @tags         = []
      @definitions  = []
    end

    def add_tag(tag)
      @tags << tag
    end

    def add_operation(operation)
      @paths[operation.path] ||= Path.new(operation.path)
      @paths[operation.path].add_operation(operation)
      @definitions.concat(operation.definitions)
    end

    def to_doc
      {
        'swagger' => Swaggard.configuration.swagger_version,
        'info' => {
          'description'     => Swaggard.configuration.description,
          'version'         => Swaggard.configuration.api_version,
          'title'           => Swaggard.configuration.title,
          'termsOfService'  => Swaggard.configuration.tos,
          'contact' => {
            'email' => Swaggard.configuration.contact
          },
          'license' => {
            'name'  => Swaggard.configuration.license_name,
            'url'   => Swaggard.configuration.license_url
          }
        },
        'host'        => Swaggard.configuration.host,
        'basePath'    => Swaggard.configuration.api_base_path,
        'tags'        => @tags.map(&:to_doc),
        'schemes'     => Swaggard.configuration.schemes,
        'paths'       => Hash[@paths.values.map { |path| [path.path, path.to_doc] }],
        'definitions' => Hash[@definitions.map { |definition| [definition.id, definition.to_doc] }]
      }
    end

  end
end