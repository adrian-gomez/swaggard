$:.push File.expand_path('../lib', __FILE__)

require 'swaggard/version'

Gem::Specification.new do |s|

  s.name        = 'swaggard'
  s.version     = Swaggard::VERSION
  s.authors     = ['Adrian Gomez']
  s.email       = ['adrian.gomez@moove-it.com']
  s.homepage    = 'https://github.com/Moove-it/swaggard'
  s.summary     = %q{Swaggard: Swagger Rails REST API doc using yard YARD}
  s.description = %q{Generate swagger documentation for your Rails REST API using YARD}
  s.licenses    = ['MIT']

  s.files = Dir['{app,config,public,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.0'
  s.add_dependency 'sass-rails'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'bourne'
  s.add_development_dependency 'simplecov'

  s.add_runtime_dependency 'yard'

end
