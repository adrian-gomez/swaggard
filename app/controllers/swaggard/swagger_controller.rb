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
          doc = Swaggard.get_doc(request.host_with_port)

          render json: doc
        end
      end
    end

  end
end