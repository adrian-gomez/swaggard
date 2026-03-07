# Swaggard

Swaggard is a Rails Engine that documents a REST API by generating a JSON file compliant with [OpenAPI 3.1](https://spec.openapis.org/oas/v3.1.0) and displaying it using [Swagger UI 5](https://github.com/swagger-api/swagger-ui).
This gem is inspired and based on [SwaggerYard](https://github.com/synctv/swagger_yard) by [Chris Trinh](https://github.com/chtrinh).


## Compatibility

Swaggard Version | OpenAPI Version | Swagger UI Version  | Supported Rails Versions
---------------- | --------------- | ------------------- | ------------------------
4.0.x            | 3.1             | 5.32.0              | 7 - 8
2.0.x            | 2.0             | 2.2.8               | 7 - 8
1.1.x            | 2.0             | 2.2.8               | 4 - 6
1.0.x            | 2.0             | 2.2.8               | 4 - 5
0.5.x            | 2.0             | 2.2.8               | 4 - 5
0.4.x            | 2.0             | 2.2.8               | 4
0.3.x            | 2.0             | 2.1.3               | 4
0.2.x            | 2.0             | 2.1.3               | 4
0.1.x            | 2.0             | 2.1.3               | 4
0.0.x            | 2.0             | 2.1.8-M1            | 4


## Installation

Put Swaggard in your Gemfile:

    gem 'swaggard'

Install the gem with Bundler:

    bundle install


## Getting Started

Generate a Swaggard configuration initializer:

    rails g swaggard:install

This installs `config/initializers/swaggard.rb` which you can edit to configure the gem.

Mount the engine:

    # config/routes.rb
    mount Swaggard::Engine, at: '/api_docs/swagger/'

Access the documentation UI:

    open http://localhost:3000/api_docs/swagger/

Access the raw OpenAPI JSON:

    open http://localhost:3000/api_docs/swagger.json


## Example

By just using Swaggard you'll get documentation for the endpoints that exist on your service:
HTTP method, path, and path parameters. Grouping is done based on the controller that holds each path.

Add YARD comments to provide richer documentation:

    # config/routes.rb

    resources :users, only: [] do
      resources :posts, controller: 'users/posts', only: [:index, :create]
    end


    # app/controllers/users/posts_controller.rb

    # @tag UsersPosts
    # API for creating, deleting, and listing user posts.
    class Users::PostsController < ActionController::Base

      # Returns the list of user posts
      #
      # @response_status 201
      # @response_root posts
      # @response_class Array<PostSerializer>
      def index
        ...
      end

      # Create user post
      #
      # @body_parameter [string] title
      # @body_parameter [string] body
      # @body_parameter [string] topic_id
      #
      # @response_class PostSerializer
      def create
        ...
      end

    end


    # app/serializers/post_serializer.rb

    # @attr [integer] id
    # @attr [string] title
    # @attr [string] body
    # @attr [date-time] created_at
    # @attr [date-time] updated_at
    # @attr [TopicSerializer] topic
    class PostSerializer < ActiveModel::Serializer

      attribute :id
      attribute :title
      attribute :body
      attribute :created_at
      attribute :updated_at

      has_one :topic, serializer: TopicSerializer

    end


    # app/serializers/topic_serializer.rb

    # @attr [integer] id
    # @attr [string] name
    # @attr [date-time] created_at
    # @attr [date-time] updated_at
    class TopicSerializer < ActiveModel::Serializer

      attribute :id
      attribute :name
      attribute :created_at
      attribute :updated_at

    end


## Available Tags

### Controllers

- `@tag name` — Group this controller under `name`. Defaults to the controller path if `ignore_untagged_controllers` is false.
- `@query_parameter [type] name` — Query string parameter.
- `@body_parameter [type] name` — Request body property. Generates a `requestBody` in the OpenAPI output.
- `@form_parameter [type] name` — Form data parameter (`application/x-www-form-urlencoded`).
- `@parameter_list` — Enum-style query parameter list.
- `@response_class type` — Response schema type. Supports `Array<Type>` for array responses.
- `@response_status 200` — HTTP response status code.
- `@response_root name` — Wrap the response in a root key.
- `@response_description text` — Description for the response.
- `@response_example path/to/example.json` — Example response. Inlined if the file exists on disk, otherwise used as an `externalValue` URI.
- `@response_header [type] name description` — Response header.
- `@operation_id id` — Override the `operationId`.
- `@body_required` — Mark the request body as required.
- `@body_title title` — Title for the generated request body schema.
- `@body_definition SchemaName` — Reference an existing schema by name as the request body.

To document all controllers including those without a `@tag`:

    Swaggard.configure do |config|
      config.ignore_untagged_controllers = false
    end


### Models

- `@attr [type] name` — Model attribute.
- `@ignore_inherited` — Do not inherit properties from parent class.


## Primitives

When one of these types is used Swaggard maps it to an inline schema instead of a `$ref`:

- integer
- long
- float
- double
- string
- byte
- binary
- boolean
- date
- date-time
- password
- hash


## Custom Types

Define reusable object schemas that are placed in `components/schemas` and referenced via `$ref`:

    Swaggard.configure do |config|
      config.add_custom_type('Address', type: :object,
        properties: {
          line1: { type: :string },
          city:  { type: :string },
          state: { type: :string },
          zip:   { type: :string },
        },
        required: %i[line1 city state zip])
    end


## Authentication

Swaggard supports injecting auth credentials into every request via `requestInterceptor`.

    Swaggard.configure do |config|
      config.authentication_type  = 'header' # or 'query'. Defaults to 'query'
      config.authentication_key   = 'X-AUTH-TOKEN' # Defaults to 'api_key'
      config.authentication_value = 'your-secret-key' # Defaults to ''
    end

For OAuth2 / API key schemes visible in the Swagger UI Authorize dialog, use `add_security_definition` and `add_security`:

    Swaggard.configure do |config|
      config.add_security_definition('api_key', type: 'apiKey', name: 'Authorization', in: 'header')
      config.add_security('api_key')
    end


## Access Authorization

Protect the documentation UI with HTTP Basic auth:

    Swaggard.configure do |config|
      config.access_username = 'admin'
      config.access_password = 'password'
    end

If `access_username` is not set, the UI is publicly accessible.


## Additional Parameters

Inject extra headers or query parameters into every request:

    Swaggard.configure do |config|
      config.additional_parameters = [{ key: 'STORE-CODE', type: 'header', value: '1' }]
    end

`type` can be `'header'` or `'query'`.


## Caching

Cache the generated OpenAPI JSON for better performance:

    Swaggard.configure do |config|
      config.use_cache = Rails.env.production?
    end

Clear the cache with:

    rake swaggard:clear_cache


## Documentation Scoping

Limit documentation to a subset of controllers:

    Swaggard.configure do |config|
      config.controllers_path = "#{Rails.root}/app/controllers/api/**/*.rb"
    end

Default: `"#{Rails.root}/app/controllers/**/*.rb"`.


## More Information

- [OpenAPI 3.1 Specification](https://spec.openapis.org/oas/v3.1.0)
- [Swagger UI](https://github.com/swagger-api/swagger-ui)
- [YARD](https://github.com/lsegal/yard)


## Author

[Adrian Gomez](https://github.com/adrian-gomez)


## Credits

[Chris Trinh](https://github.com/chtrinh) — author of [SwaggerYard](https://github.com/synctv/swagger_yard), which this gem is inspired by and based on.
