require 'action_controller/railtie'

# Load Swaggard
require File.expand_path('../../../../../lib/swaggard', __FILE__)

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path('../../', __FILE__)

    # Disable the asset pipeline.
    config.assets.enabled = false
  end
end

Dummy::Application.initialize!