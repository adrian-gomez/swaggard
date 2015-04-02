require 'spec_helper'

require 'json-schema'

describe Swaggard, '.get_doc' do

  let(:controller_path) { File.expand_path('../../fixtures/dummy/app/controllers/pets_controller.rb', __FILE__) }
  let(:api_json)        { File.read(File.expand_path('../../fixtures/api.json', __FILE__)) }

  let(:host) { 'localhost:3000' }

  it 'generates the expected swagger json' do
    Swaggard.configure do |config|
      config.controllers_path = controller_path
      config.routes = Dummy::Application.routes.routes
    end

    swagger_json = JSON.dump(Swaggard.get_doc(host))

    expect(swagger_json).to eq(api_json)
  end

end