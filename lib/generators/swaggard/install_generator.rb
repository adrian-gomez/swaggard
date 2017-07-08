module Swaggard
  class InstallGenerator < Rails::Generators::Base

    desc "Installs a Swaggard initializer config"
    source_root File.expand_path("../templates", __FILE__)

    def create_initializer
      dest = File.join("config/initializers", "swaggard.rb")
      template "swaggard.rb", dest
    end

  end
end
