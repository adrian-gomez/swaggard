require 'rails/all'

# Load Swaggard
require File.expand_path('../../../../../lib/swaggard', __FILE__)

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path('../../', __FILE__)
  end
end

Dummy::Application.initialize!
