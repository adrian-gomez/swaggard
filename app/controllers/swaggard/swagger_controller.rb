module Swaggard
  class SwaggerController < ApplicationController

    before_filter :authorize

    def index
      respond_to do |format|
        format.html do
          @authentication_type = Swaggard.configuration.authentication_type
          @authentication_key = Swaggard.configuration.authentication_key
          @authentication_value = Swaggard.configuration.authentication_value

          render :index, layout: false
        end

        format.json do
          doc = Swaggard.get_doc(request.host_with_port)

          render json: doc
        end
      end
    end

    protected
    def authorize
      unless Swaggard.configuration.access_username.blank?
        authenticate_or_request_with_http_basic do |username, password|
          username == Swaggard.configuration.access_username && password == Swaggard.configuration.access_password
        end
      end
    end

  end
end