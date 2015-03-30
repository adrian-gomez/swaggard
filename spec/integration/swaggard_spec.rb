require 'spec_helper'

describe Swaggard, '.get_doc' do

  let(:controller_path) { File.expand_path('../../fixtures/dummy/app/controllers/pets_controller.rb', __FILE__) }
  let(:api_json)        { File.read(File.expand_path('../../fixtures/api.json', __FILE__)) }

  it 'generates swagger json' do
    Swaggard.configure do |config|
      config.controllers_path = controller_path
      config.routes = Dummy::Application.routes.routes
    end

    swagger_json = JSON.dump(Swaggard.get_doc)

    expect(swagger_json).to eq(api_json)
  end

end