if Rails::Application.instance_methods.include?(:assets_manifest)
  Rails.application.config.assets.precompile += %w[ swaggard/application.js
                                                    swaggard/application.css
                                                    swaggard/application_print.css
                                                    swaggard/favicon-32x32.png
                                                    swaggard/favicon-16x16.png
                                                    swaggard/lang/ca.js
                                                    swaggard/lang/el.js
                                                    swaggard/lang/en.js
                                                    swaggard/lang/es.js
                                                    swaggard/lang/fr.js
                                                    swaggard/lang/geo.js
                                                    swaggard/lang/it.js
                                                    swaggard/lang/ja.js
                                                    swaggard/lang/ko-kr.js
                                                    swaggard/lang/pl.js
                                                    swaggard/lang/pt.js
                                                    swaggard/lang/ru.js
                                                    swaggard/lang/tr.js
                                                    swaggard/lang/zh-cn.js
                                                    swaggard/logo_small.png
                                                ]
end
