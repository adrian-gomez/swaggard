module Swaggard

  # Configuration for Swagger Yard, use like:
  #
  #   Swaggard.configure do |config|
  #     config.swagger_version = "1.1"
  #     config.api_version = "0.1"
  #     config.doc_base_path = "http://swagger.example.com/doc"
  #     config.api_base_path = "http://swagger.example.com/api"
  #   end
  class Configuration

    attr_accessor :doc_base_path, :api_base_path

    attr_writer :swagger_version, :api_version, :api_path, :api_formats

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

  end
end