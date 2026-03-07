require 'spec_helper'

require 'json_schemer'

describe Swaggard, '.get_doc OAS 3.1 validation' do
  let(:controller_path) { File.expand_path('../../fixtures/dummy/app/controllers/**/*.rb', __FILE__) }
  let(:schema_path)     { File.expand_path('../../fixtures/openapi_3_1_schema.json', __FILE__) }
  let(:host)            { 'localhost:3000' }

  subject(:doc) do
    Swaggard.configure do |config|
      config.controllers_path = controller_path
      config.routes = Dummy::Application.routes.routes
      config.ignore_untagged_controllers = false
    end

    Swaggard.get_doc(host)
  end

  it 'conforms to the OAS 3.1 JSON Schema' do
    schema   = JSONSchemer.schema(Pathname.new(schema_path))
    errors   = schema.validate(doc).to_a

    expect(errors).to be_empty, -> {
      errors.map { |e| JSONSchemer::Errors.pretty(e) }.join("\n")
    }
  end
end
