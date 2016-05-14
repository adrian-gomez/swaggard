module ApplicationResolver

  # Load Rails, which loads our swaggard
  def dummy_app_path
    major = ENV['RAILS_MAJOR_VERSION'] || '4'
    minor = ENV['RAILS_MINOR_VERSION'] || '2'

    Pathname.new(File.expand_path("../../fixtures/dummy_rails_#{major}_#{minor}", __FILE__))
  end

end

# This is to have the dummy_app_path available to require the rails app.
include ApplicationResolver

require dummy_app_path.join('config', 'application.rb')

RSpec.configure do |config|
  config.include ApplicationResolver
end
