require 'spec_helper'

describe Swaggard, '.generate' do

  let(:controller_path) {File.expand_path('../../fixtures/dummy/app/controllers/pets_controller.rb', __FILE__)}
  let(:api_json) {File.read(File.expand_path('../../fixtures/api.json', __FILE__))}

  it 'generates swagger api json for the given controller' do
    Swaggard.generate!(controller_path, '', Dummy::Application.routes.routes)

    puts JSON(Swaggard.get_doc)

    swagger_json = JSON.dump(Swaggard.get_doc)

    expect(swagger_json).to eq(api_json)
  end

end