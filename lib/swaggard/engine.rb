module Swaggard
  class Engine < ::Rails::Engine
    isolate_namespace Swaggard

    initializer 'swaggard.finisher_hook', :after => :finisher_hook do |app|
      app.reload_routes!

      Swaggard.configure do |config|
        unless config.controllers_path
          config.controllers_path = "#{app.root}/app/controllers/**/*.rb"
        end

        unless config.models_paths
          config.models_paths = ["#{app.root}/app/serializers/**/*.rb"]
        end

        config.routes = app.routes.routes
      end

      Swaggard.register_custom_yard_tags!
    end

    config.to_prepare do
      Rails.application.config.assets.precompile += %w(
        swaggard/application_print.css
        swaggard/favicon-16x16.png
        swaggard/favicon-32x32.png
      )
    end


  end
end
