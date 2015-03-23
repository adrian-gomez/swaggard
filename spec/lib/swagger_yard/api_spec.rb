require 'spec_helper'

describe Swaggard::Api do
  context "with a parsed yard object" do
    let(:yard_object) {stub(docstring: 'A Description')}

    let(:api) {Swaggard::Api.new(yard_object)}

    context "with a path" do
      let(:tags) { [stub(tag_name: "path", text: "[GET] /accounts/ownerships.{format_type}")] }

      before(:each) do
        yard_object.stubs(:tags).returns(tags)
      end

      it 'is valid?' do
        expect(api.valid?).to be_true
      end
    end
  end
end
