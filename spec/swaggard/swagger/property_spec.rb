require 'spec_helper'

describe Swaggard::Swagger::Property do
  describe '#to_doc' do
    let(:type) { Swaggard::Swagger::Type.new(:string) }

    it 'emits the type only by default' do
      property = described_class.new('name', type)

      expect(property.to_doc).to eq('type' => 'string')
    end

    it 'emits the description when present' do
      property = described_class.new('name', type, 'The full name')

      expect(property.to_doc).to eq('type' => 'string', 'description' => 'The full name')
    end

    it 'emits deprecated when the property is deprecated' do
      property = described_class.new('name', type, '', false, [], true)

      expect(property.to_doc).to eq('type' => 'string', 'deprecated' => true)
      expect(property).to be_deprecated
    end

    it 'does not emit deprecated when the property is not deprecated' do
      property = described_class.new('name', type)

      expect(property.to_doc).not_to have_key('deprecated')
      expect(property).not_to be_deprecated
    end
  end
end
