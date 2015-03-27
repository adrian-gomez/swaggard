module Swaggard
  class SwaggerController < ApplicationController

    def index
      swagger_listing = Swaggard.get_doc

      render :json => swagger_listing
    end

    def doc
      @authentication_type = Swaggard.configuration.authentication_type
      @authentication_key = Swaggard.configuration.authentication_key
      @authentication_value = Swaggard.configuration.authentication_value

      render :doc
    end

  end
end