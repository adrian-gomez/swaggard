module Swaggard
  class Engine < ::Rails::Engine
    isolate_namespace Swaggard

    initializer "swaggard.finisher_hook", :after => :finisher_hook do |app|
      app.reload_routes!

      Swaggard.generate!("#{app.root}/app/controllers/**/*.rb",
                         "#{app.root}/app/serializers/**/*.rb",
                         app.routes.routes)
    end

  end
end