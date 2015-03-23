module Swaggard
  class ApiDeclaration

    attr_accessor :description, :resource_path, :file_path

    attr_accessor :klass

    def initialize(models)
      @apis   = {}
      @models = models
    end

    def add_listing_info(yard_object)
      if !yard_object.name.to_s.ends_with?('Controller') || yard_object.name.to_s == 'ApplicationController'
        return false
      end

      @klass = "#{yard_object.namespace}::#{yard_object.name}".constantize
      @description = yard_object.docstring || ''
      @file_path = "/#{@klass.controller_path}"
      @resource_path =  '/'+ "#{@klass.controller_path}".gsub('/', '-')

      @resource_path.present?
    end

    def add_api(api)
      if @apis.keys.include?(api.path)
        same_api_path = @apis[api.path]
        same_api_path["operations"] << api.operation
        @apis[api.path] = same_api_path
      else
        @apis[api.path] = api.to_h
      end
    end

    def resource_name
      @resource_path
    end

    def to_h
      {
        "apiVersion"     => Swaggard.configuration.api_version,
        "swaggerVersion" => Swaggard.configuration.swagger_version,
        "basePath"       => Swaggard.configuration.api_base_path,
        "resource_path"  => @resource_path,
        "apis"           => @apis.values,
        "models"         => Hash[@models.map {|m| [m.id, m.to_h]}]
      }
    end

  end
end