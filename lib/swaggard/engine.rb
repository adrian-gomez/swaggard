module Swaggard
  class Engine < ::Rails::Engine
    isolate_namespace Swaggard

    initializer 'swaggard.finisher_hook', :after => :finisher_hook do |app|
      app.reload_routes!

      Swaggard.configure do |config|
        config.controllers_path = "#{app.root}/app/controllers/**/*.rb"
        config.models_path = "#{app.root}/app/serializers/**/*.rb"
        config.routes = app.routes.routes
      end

      Swaggard.register_custom_yard_tags!
    end

  end
end