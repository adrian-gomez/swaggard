# Swaggard configuration settings and their current default values... override
# as you see fit.
#
# For more info on configuration settings see http://swagger.io/specification/

Swaggard.configure do |config|
  # Set an access password.
  # See https://github.com/adrian-gomez/swaggard#access-authorization for more info
  # config.access_password = ""

  # Set an access username. If you don't set an access_username, everyone will
  # have access to Swagger documentation.
  # See https://github.com/adrian-gomez/swaggard#access-authorization for more info
  # config.access_username = ""

  # Swaggard supports additional parameters to be sent on every request,
  # either as a header or as part of the query.
  # See https://github.com/adrian-gomez/swaggard#additional-parameters for more info
  # config.additional_parameters = []

  # The base path on which the API is served, which is relative to the host.
  # If it is not included, the API is served directly under the host.
  # The value MUST start with a leading slash (/).
  # config.api_base_path = "/"

  # Specify the API formats.
  # config.api_formats = [:xml, :json]

  #  The version of the application API.
  # config.api_version = "0.1"

  # Set an API authentication key
  # See https://github.com/adrian-gomez/swaggard#authentication for more details
  # config.authentication_key = "api_key"

  # Set the API authentication type, either header or query
  # See https://github.com/adrian-gomez/swaggard#authentication for more details
  # config.authentication_type = "query"

  # Set the API authentication value
  # See https://github.com/adrian-gomez/swaggard#authentication for more details
  # config.authentication_value = ""

  # The contact email for the API.
  # config.contact_email = ""

  # The contact email for the API.
  # config.contact_name = ""

  # The contact url for the API.
  # config.contact_url = ""

  # Specify where to look for your controllers
  # config.controllers_path = "#{Rails.root}/app/controllers/**/*.rb"

  # Specify a default content type for requests to use in SwaggerUI.
  # See https://github.com/adrian-gomez/swaggard#default-content-type for more info
  # config.default_content_type = ""

  # A short description of the application.
  # config.description = ""

  # The host (name or ip) serving the API.
  # This MUST be the host only and does not include the scheme nor sub-paths.
  # config.host = ""

  # The language to display SwaggerUI in.
  # See https://github.com/adrian-gomez/swaggard#language for more info
  # config.language = "en"

  # The name of the Licence eg. MIT
  # config.license_name = ""

  # The URL of the Licence info
  # config.license_url = ""

  # Specify one or more paths to look for your model documentation
  # config.models_paths = ["#{Rails.root}/app/serializers/**/*.rb"]

  # The transfer protocol of the API.
  # Values MUST be from the list: "http", "https", "ws", "wss"
  # config.schemes = [:https, :http]

  # Specifies the Swagger Specification version being used.
  # config.swagger_version = "2.0"

  # The title of the application/API.
  # config.title = ""

  # The Terms of Service for the API.
  # config.tos = ""

  # Specify whether to cache the Swagger docs or not.
  # See https://github.com/adrian-gomez/swaggard#caching for more info
  # config.use_cache = false
end
