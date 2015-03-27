Swaggard
========

Swaggard is a Rails Engine that can be used to document a REST api. It does this by generating a
json that is compliant with [Swagger](http://swagger.io) and displaying it using [Swagger-ui](https://github.com/wordnik/swagger-ui).
This gem is inspired and based on [SwaggerYard](https://github.com/synctv/swagger_yard) by [Chris Trinh](https://github.com/chtrinh). 
 
 
Swaggard vs SwaggerYard
-----------------------

The main reason this gem exists is to avoid having to write by hand some information and use what
rails already give us ie: controllers names and methods paths.

And also:
  - Bring support for Rails 4.
  - Bring support for Swagger 2.
  - Bring support for models (serializers).
  - Bring support for form and body params.
  - and more...


Installation
------------
  
Put Swaggard in your Gemfile:

    gem 'swaggard'

Install the gem with Bundler:

    bundle install


Getting Started
-----------------

Place your configuration in a your rails initializers
    
    # config/initializers/swaggard.rb

    Swaggard.configure do |config|
      config.api_version = '0.1'
      config.doc_base_path = 'http://swagger.example.com/doc'
      config.api_base_path = 'http://swagger.example.com/api'
    end

Mount your engine

	# config/routes.rb

	mount Swaggard::Engine, at: '/swagger'


Example
-------

Here is a example of how to use Swaggard

    # app/controllers/users/posts_controller.rb

    # User posts
    #
    # API for creating, deleting, and listing user posts.
    class User::PostsController < ActionController::Base

      # Returns the list of user posts
      #
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

![Web UI](https://raw.github.com/Moove-it/swaggard/master/example/web-ui.png)


Authentication
--------------

Swaggard supports two types of authentication: header and query.

You can configure it as follows:

    # config/initializers/swaggard.rb
    Swaggard.configure do |config|
      config.authentication_type  = 'header' # Defaults to 'query'
      config.authentication_key   = 'X-AUTH-TOKEN' # Defaults to 'api_key'
      config.authentication_value = 'your-secret-key' # Initial value for authentication. Defaults to ''
    end

Even if you provide a authentication_value you can later change it from the ui.

More Information
-----------------

- [Swagger](http://swagger.io)
- [Swagger-ui](https://github.com/wordnik/swagger-ui)
- [Yard](https://github.com/lsegal/yard)


Author
------

[Adrian Gomez](https://github.com/adrian-gomez)


Credits
-------

[Chris Trinh](https://github.com/chtrinh) author of [SwaggerYard](https://github.com/synctv/swagger_yard) in which this gem is
inspired and used a base.