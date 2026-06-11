require 'spec_helper'

describe Swaggard::Parsers::Property do
  def yard_tag(name, text: 'A description', types: ['string'])
    YARD::Tags::Tag.new('attr', text, types, name)
  end

  describe '.run' do
    it 'parses a plain attribute' do
      property = described_class.run(yard_tag('name'))

      expect(property.id).to eq('name')
      expect(property).not_to be_required
      expect(property).not_to be_deprecated
    end

    it 'parses the required marker' do
      property = described_class.run(yard_tag('!name'))

      expect(property.id).to eq('name')
      expect(property).to be_required
    end

    it 'parses the deprecated marker' do
      property = described_class.run(yard_tag('uses_tobacco(deprecated)', types: ['boolean']))

      expect(property.id).to eq('uses_tobacco')
      expect(property).to be_deprecated
      expect(property.to_doc).to include('deprecated' => true)
    end

    it 'combines the required and deprecated markers' do
      property = described_class.run(yard_tag('!name(deprecated)'))

      expect(property.id).to eq('name')
      expect(property).to be_required
      expect(property).to be_deprecated
    end
  end
end
