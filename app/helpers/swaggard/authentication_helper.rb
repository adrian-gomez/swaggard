module Swaggard
  module AuthenticationHelper

    def authentication_type
      Swaggard.configuration.authentication_type
    end

    def authentication_key
      Swaggard.configuration.authentication_key
    end

    def authentication_value
      Swaggard.configuration.authentication_value
    end

  end
end