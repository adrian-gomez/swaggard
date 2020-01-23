if Rails::Application.instance_methods.include?(:assets_manifest)
  Rails.application.config.assets.precompile += %w[swaggard/application_print.css
                                                   swaggard/favicon-32x32.png
                                                   swaggard/favicon-16x16.png
                                                   swaggard/lang/*.js
                                                   swaggard/logo_small.png]

end
