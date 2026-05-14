require 'spec_helper'

describe Swaggard::Swagger::Definition do
  let(:property) { Swaggard::Swagger::Property.new('name', Swaggard::Swagger::Type.new(:string)) }

  describe '#to_doc' do
    context 'when collection is false (default)' do
      subject(:definition) { described_class.new('Foo') }

      before { definition.add_property(property) }

      it 'emits a type: object schema with inline properties' do
        expect(definition.to_doc({})).to eq(
          'type' => 'object',
          'properties' => { 'name' => { 'type' => 'string' } }
        )
      end
    end

    context 'when collection is true' do
      subject(:definition) { described_class.new('Foo_all', collection: true) }

      before { definition.add_property(property) }

      it 'emits a type: array schema with properties wrapped under items' do
        expect(definition.to_doc({})).to eq(
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => { 'name' => { 'type' => 'string' } }
          }
        )
      end

      context 'with required properties' do
        let(:property) do
          Swaggard::Swagger::Property.new('name', Swaggard::Swagger::Type.new(:string), '', true)
        end

        it 'places the required array inside items' do
          doc = definition.to_doc({})

          expect(doc['required']).to be_nil
          expect(doc['items']['required']).to eq(['name'])
        end
      end
    end
  end
end
