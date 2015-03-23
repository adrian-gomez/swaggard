module Swaggard
  class SwaggerController < ApplicationController
    layout false

    def index
      swagger_listing = Swaggard.get_listing
      swagger_listing.merge!("basePath" => request.url) if swagger_listing["basePath"].blank?

      render :json => swagger_listing
    end

    def show
      swagger_api = Swaggard.get_api("/#{params[:resource]}")
      swagger_api.merge!("basePath" => request.base_url + Swaggard.api_path) if swagger_api["basePath"].blank?
      render :json => swagger_api
    end

    def doc
      render :doc
    end

  end
end