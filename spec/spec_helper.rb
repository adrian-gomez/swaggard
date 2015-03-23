require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] = "development"

require 'bundler/setup'

require 'rspec'
require 'mocha/api'
require 'bourne'

# Load Rails, which loads our swaggard
require File.expand_path('../fixtures/dummy/config/application.rb', __FILE__)

# require File.expand_path('../../lib/swaggard', __FILE__)

# Dir["./spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.mock_with :mocha

  config.order = 'random'
end
