$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "swaggard/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "swaggard"
  s.version     = Swaggard::VERSION
  s.authors     = ['Adrian Gomez']
  s.email       = ['adrian.gomez@moove-it.com']
  s.homepage    = "http://www.synctv.com"
  s.summary     = %q{Swaggard: Swagger REST API doc using yard YARD}
  s.description = %q{Generate swagger documentation for your Rails REST API using YARD}
  s.licenses    = ['MIT']

  s.files = Dir['{app,config,public,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 4.0'

  s.add_development_dependency "rspec"
  s.add_development_dependency "bourne"
  s.add_development_dependency "simplecov"

  s.add_runtime_dependency 'yard'
end
