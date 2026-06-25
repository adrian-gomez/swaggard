require 'spec_helper'

describe Swaggard::ApiDefinition do
  describe '#format_path' do
    subject(:formatted) { described_class.new.send(:format_path, path) }

    let(:original_base_path) { Swaggard.configuration.api_base_path }
    let(:original_exclude)   { Swaggard.configuration.exclude_base_path_from_paths }

    before do
      original_base_path
      original_exclude
      Swaggard.configuration.api_base_path = '/api'
      Swaggard.configuration.exclude_base_path_from_paths = true
    end

    after do
      Swaggard.configuration.api_base_path = original_base_path
      Swaggard.configuration.exclude_base_path_from_paths = original_exclude
    end

    context 'when the base path also appears inside a later path segment' do
      let(:path) { '/api/partner/api_keys' }

      it 'strips only the leading base path, not every occurrence' do
        expect(formatted).to eq('/partner/api_keys')
      end
    end

    context 'with a path that only contains the leading base path' do
      let(:path) { '/api/partner/products' }

      it 'strips the leading base path' do
        expect(formatted).to eq('/partner/products')
      end
    end

    context 'when exclude_base_path_from_paths is disabled' do
      let(:path) { '/api/partner/api_keys' }

      before { Swaggard.configuration.exclude_base_path_from_paths = false }

      it 'returns the path unchanged' do
        expect(formatted).to eq('/api/partner/api_keys')
      end
    end
  end
end
