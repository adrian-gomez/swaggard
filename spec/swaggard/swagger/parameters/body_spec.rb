require 'spec_helper'

describe Swaggard::Swagger::Parameters::Body do
  subject(:body) { described_class.new('PetsController.create') }

  def property_doc(name)
    body.definition.to_doc({})['properties'][name]
  end

  describe '#add_property' do
    it 'parses type, name and description' do
      body.add_property('[String] name The name of the pet')

      expect(property_doc('name')).to eq('type' => 'string', 'description' => 'The name of the pet')
    end

    it 'parses the required marker' do
      body.add_property('[String]! name The name of the pet')

      expect(body.definition.to_doc({})['required']).to eq(['name'])
    end

    it 'parses the deprecated marker' do
      body.add_property('[Boolean] uses_tobacco(deprecated) Use lifestyle instead.')

      expect(property_doc('uses_tobacco')).to eq(
        'type' => 'boolean',
        'description' => 'Use lifestyle instead.',
        'deprecated' => true
      )
    end

    it 'combines the required and deprecated markers' do
      body.add_property('[String]! name(deprecated) The name of the pet')

      expect(property_doc('name')['deprecated']).to be(true)
      expect(body.definition.to_doc({})['required']).to eq(['name'])
    end

    it 'keeps enum options working alongside the deprecated marker' do
      body.add_property('[String] status(deprecated) [active,inactive] The status')

      expect(property_doc('status')).to eq(
        'type' => 'string',
        'description' => ' The status',
        'enum' => %w[active inactive],
        'deprecated' => true
      )
    end
  end
end
