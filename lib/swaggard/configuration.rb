module Swaggard

  # Configuration for Swagger Yard, use like:
  #
  #   Swaggard.configure do |config|
  #     config.api_version          = '0.1'
  #     config.doc_base_path        = 'http://swagger.example.com/doc'
  #     config.api_base_path        = 'http://swagger.example.com/api'
  #     config.authentication_type  = 'header'
  #     config.authentication_key   = 'X-AUTHORIZATION'
  #     config.authentication_value = 'you-secret-key'
  #   end
  class Configuration

    attr_accessor :doc_base_path, :controllers_path, :models_paths, :routes

    attr_writer :swagger_version, :api_base_path, :api_version, :api_path, :api_formats, :title,
                :description, :tos, :contact_email, :contact_name, :contact_url, :host,
                :authentication_type, :authentication_key, :authentication_value,
                :access_username, :access_password, :default_content_type, :use_cache, :module_name

    def swagger_version
      @swagger_version ||= '2.0'
    end

    def api_version
      @api_version ||= '0.1'
    end

    def api_path
      @api_path ||= ''
    end

    def api_base_path
      @api_base_path ||= '/'
    end

    def api_formats
      @api_formats ||= [:xml, :json]
    end

    def host
      @host ||= ''
    end

    def schemes
      @schemes ||= [:http]
    end

    def title
      @title ||= ''
    end

    def description
      @description ||= ''
    end

    def tos
      @tos ||= ''
    end

    def contact_name
      @contact_name ||= ''
    end

    def contact_email
      @contact_email ||= ''
    end

    def contact_url
      @contact_email ||= ''
    end

    def license_name
      @license_name ||= ''
    end

    def license_url
      @license_url ||= ''
    end

    def authentication_type
      @authentication_type ||= 'query'
    end

    def authentication_key
      @authentication_key ||= 'api_key'
    end

    def authentication_value
      @authentication_value ||= ''
    end

    def access_username
      @access_username ||= ''
    end

    def access_password
      @access_password ||= ''
    end

    def default_content_type
      @default_content_type ||= ''
    end

    def use_cache
      @use_cache ||= false
    end

    def module_name
      @module_name ||= ''
    end

  end
end