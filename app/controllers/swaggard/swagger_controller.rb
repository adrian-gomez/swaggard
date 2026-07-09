module Swaggard
  class SwaggerController < ApplicationController

    before_action :authorize

    def index
      respond_to do |format|
        format.html do
          @authentication_type = Swaggard.configuration.authentication_type
          @authentication_key = Swaggard.configuration.authentication_key
          @authentication_value = Swaggard.configuration.authentication_value.respond_to?(:call) ?
                                    Swaggard.configuration.authentication_value.call :
                                    Swaggard.configuration.authentication_value

          render :index, layout: false
        end

        format.json do
          render json: get_swaggard_doc_json, :adapter => :attributes
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

    def get_swaggard_doc_json
      if Swaggard.configuration.use_cache
        doc_json = Rails.cache.fetch('swaggard_doc_json')
        if doc_json.blank?
          doc_json = Swaggard.get_doc(request.host_with_port).as_json
          Rails.cache.write('swaggard_doc_json', doc_json)
        end
        doc_json
      else
        Swaggard.get_doc(request.host_with_port).as_json
      end
    end

  end
end
