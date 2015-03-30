module Swaggard
  class SwaggerController < ApplicationController

    def index
      respond_to do |format|
        format.html do
          @authentication_type = Swaggard.configuration.authentication_type
          @authentication_key = Swaggard.configuration.authentication_key
          @authentication_value = Swaggard.configuration.authentication_value

          render :index
        end

        format.json do
          render :json => Swaggard.get_doc
        end
      end
    end

  end
end