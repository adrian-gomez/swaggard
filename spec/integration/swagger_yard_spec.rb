require 'spec_helper'

describe Swaggard, '.generate' do

  let(:controller_path) {File.expand_path('../../fixtures/dummy/app/controllers/pets_controller.rb', __FILE__)}
  let(:pets_json) {File.read(File.expand_path('../../fixtures/pets.json', __FILE__))}

  let(:swagger_json) {JSON.dump(Swaggard.generate!(controller_path))}

  it 'generates swagger api json for the given controller' do
    expect(swagger_json).to eq(pets_json)
  end
end
