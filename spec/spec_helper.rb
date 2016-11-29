require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] = "development"

require 'bundler/setup'

require 'rspec'
require 'mocha/api'
require 'bourne'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.mock_with :mocha

  config.order = 'random'
end
