require_relative 'swagger/path'

module Swaggard
  class ApiDefinition
    attr_accessor :definitions

    def initialize
      @paths        = {}
      @tags         = {}
      @definitions  = []
    end

    def add_tag(tag)
      @tags[tag.name] ||= tag

      @tags[tag.name].description = tag.description unless tag.description.blank?
    end

    def add_operation(operation)
      @paths[operation.path] ||= Swagger::Path.new(operation.path)
      @paths[operation.path].add_operation(operation)
      @definitions.concat(operation.definitions)
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

      {
        'swagger' => Swaggard.configuration.swagger_version,
        'info' => {
          'version'         => Swaggard.configuration.api_version,
          'title'           => Swaggard.configuration.title,
          'description'     => Swaggard.configuration.description,
          'termsOfService'  => Swaggard.configuration.tos,
          'contact'         => contact,
          'license'         => license,
        },
        'host'        => Swaggard.configuration.host,
        'basePath'    => Swaggard.configuration.api_base_path,
        'schemes'     => Swaggard.configuration.schemes,
        'consumes'    => Swaggard.configuration.api_formats.map { |format| "application/#{format}" },
        'produces'    => Swaggard.configuration.api_formats.map { |format| "application/#{format}" },
        'tags'        => @tags.map { |_, tag| tag.to_doc },
        'paths'       => Hash[@paths.values.map { |path| [format_path(path.path), path.to_doc] }],
        'definitions' => Hash[@definitions.map { |definition| [definition.id, definition.to_doc] }]
      }
    end

    private

    def format_path(path)
      return path unless Swaggard.configuration.exclude_base_path_from_paths

      path.gsub(Swaggard.configuration.api_base_path, '')
    end
  end
end
