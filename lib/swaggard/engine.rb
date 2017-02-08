unless Rails::Application.instance_methods.include?(:assets_manifest)
  warn <<-END
[Swaggard] It seems you are using an api only rails setup, but swaggard
[Swaggard] neeeds sprockets in order to work so its going to require it.
[Swaggard] This might have undesired side effects, if thats not  the case
[Swaggard] you can ignore this warning.
  END
  require 'sprockets/railtie'
end

module Swaggard
  class Engine < ::Rails::Engine
    isolate_namespace Swaggard

    initializer 'swaggard.finisher_hook', after: :finisher_hook do |app|
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

  end
end
