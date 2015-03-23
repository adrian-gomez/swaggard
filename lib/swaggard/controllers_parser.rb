require_relative 'api'
require_relative 'api_declaration'
require_relative 'resource_listing'

module Swaggard
  class ControllersParser
    attr_reader :listing

    def initialize
      @listing = ResourceListing.new
    end

    def run(yard_objects, routes)
      api_declaration = ApiDeclaration.new
      retain_api = false

      yard_objects.each do |yard_object|
        if yard_object.type == :class
          retain_api = api_declaration.add_listing_info(yard_object)
          break unless retain_api
        elsif yard_object.type == :method
          api = Api.new(yard_object, api_declaration.klass, routes)
          api_declaration.add_api(api) if api.valid?
        end
      end

      return unless retain_api

      @listing.add(api_declaration)
      api_declaration
    end

  end
end