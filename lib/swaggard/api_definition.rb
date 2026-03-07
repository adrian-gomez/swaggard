require_relative 'swagger/path'

module Swaggard
  class ApiDefinition
    attr_accessor :definitions

    def initialize
      @paths        = {}
      @tags         = {}
      @definitions  = {}
    end

    def add_tag(tag)
      @tags[tag.name] ||= tag

      @tags[tag.name].description = tag.description unless tag.description.blank?
    end

    def add_operation(operation)
      @paths[operation.path] ||= Swagger::Path.new(operation.path)
      @paths[operation.path].add_operation(operation)
      @definitions.merge!(operation.definitions)
    end

    def ignore_put_if_patch!
      @paths.values.each(&:ignore_put_if_patch!)
    end

    def to_doc
      contact = { 'name'  => Swaggard.configuration.contact_name }
      contact['email'] = Swaggard.configuration.contact_email if Swaggard.configuration.contact_email.present?
      contact['url'] = Swaggard.configuration.contact_url if Swaggard.configuration.contact_url.present?

      license = { 'name'  => Swaggard.configuration.license_name }
      license['url'] = Swaggard.configuration.license_url if Swaggard.configuration.license_url.present?

      config = Swaggard.configuration
      server_url = "#{config.schemes.first}://#{config.host}#{config.api_base_path}"

      info = {
        'version'         => config.api_version,
        'title'           => config.title,
        'description'     => config.description,
        'contact'         => contact,
        'license'         => license,
      }
      info['termsOfService'] = config.tos if config.tos.present?

      doc = {
        'openapi' => '3.1.0',
        'info'    => info,
        'servers' => [{ 'url' => server_url }],
        'tags'    => @tags.map { |_, tag| tag.to_doc },
        'paths'   => Hash[@paths.values.map { |path| [format_path(path.path), path.to_doc] }],
      }

      components = build_components
      doc['components'] = components unless components.empty?
      doc['security'] = config.security unless config.security.empty?

      doc
    end

    private

    def format_path(path)
      return path unless Swaggard.configuration.exclude_base_path_from_paths

      path.gsub(Swaggard.configuration.api_base_path, '')
    end

    def build_components
      custom_type_schemas = Swaggard.configuration.custom_types
        .transform_keys { |k| Swaggard.ref_name(k) }

      definition_schemas = Hash[
        @definitions.merge(Swaggard.configuration.definitions)
          .map { |id, definition| [Swaggard.ref_name(id), definition.to_doc(@definitions)] }
      ]

      schemas = custom_type_schemas.merge(definition_schemas)

      security_schemes = Swaggard.configuration.security_definitions

      Swaggard.configuration.security.flat_map(&:keys).each do |authentication_type|
        next if security_schemes.key?(authentication_type)

        warn "#{authentication_type} not supported by components/securitySchemes"
      end

      result = {}
      result['schemas'] = schemas unless schemas.empty?
      result['securitySchemes'] = security_schemes unless security_schemes.empty?
      result
    end
  end
end
