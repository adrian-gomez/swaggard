Swaggard
========

Swaggard is a Rails Engine that can be used to document a REST api. It does this by generating a
json that is compliant with [Swagger](http://swagger.io) and displaying it using [Swagger-ui](https://github.com/wordnik/swagger-ui).
This gem is inspired and based on [SwaggerYard](https://github.com/synctv/swagger_yard) by [Chris Trinh](https://github.com/chtrinh). 
 
 
Swaggard vs SwaggerYard
-----------------------

The main reason this gem exists is to avoid having to write by hand some information and use what
rails already give us ie: controllers paths and methods paths.
And also to bring support for rails 4 and swagger 2.

Installation
------------
  
Put Swaggard in your Gemfile:

    gem 'swaggard'

Install the gem with Bunder:

    bundle install


Getting Started
-----------------

Place your configuration in a your rails initializers
    
    # config/initializers/swaggard.rb
    Swaggard.configure do |config|
      config.api_version = "0.1"
      config.doc_base_path = "http://swagger.example.com/doc"
      config.api_base_path = "http://swagger.example.com/api"
    end

Mount your engine

	# config/routes.rb
	mount Swaggard::Engine, at: "/swagger"


Example
-------

Here is a example of how to use Swaggard

    # This document describes the API for creating, reading, and deleting account ownerships.
    #
    class Accounts::OwnershipsController < ActionController::Base
      ##
      # Returns a list of ownerships associated with the account.
      #
      # Status can be -1(Deleted), 0(Inactive), 1(Active), 2(Expired) and 3(Cancelled).
      #
      # @parameter          [Integer]   offset            Used for pagination of response data (default: 25 items per response). Specifies the offset of the next block of data to receive.
      # @parameter          [Array]     status            Filter by status. (e.g. status[]=1&status[]=2&status[]=3).
      # @parameter_list     [String]    sort_order        Orders response by fields. (e.g. sort_order=created_at).
      #                     [List]      id                
      #                     [List]      begin_at          
      #                     [List]      end_at            
      #                     [List]      created_at        
      # @parameter          [Boolean]   sort_descending   Reverse order of sort_order sorting, make it descending.
      # @parameter          [Date]      begin_at_greater  Filters response to include only items with begin_at >= specified timestamp (e.g. begin_at_greater=2012-02-15T02:06:56Z).
      # @parameter          [Date]      begin_at_less     Filters response to include only items with begin_at <= specified timestamp (e.g. begin_at_less=2012-02-15T02:06:56Z).
      # @parameter          [Date]      end_at_greater    Filters response to include only items with end_at >= specified timestamp (e.g. end_at_greater=2012-02-15T02:06:56Z).
      # @parameter          [Date]      end_at_less       Filters response to include only items with end_at <= specified timestamp (e.g. end_at_less=2012-02-15T02:06:56Z).
      #
      def index
        ...
      end
    end


![Web UI](https://raw.github.com/synctv/swagger_yard/master/example/web-ui.png)

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