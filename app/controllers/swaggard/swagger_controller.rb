module Swaggard
  class SwaggerController < ApplicationController
    layout false

    def index
      swagger_listing = Swaggard.get_doc

      render :json => swagger_listing
    end

    def doc
      render :doc
    end

  end
end