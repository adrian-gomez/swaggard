require 'spec_helper'

describe Swaggard::Swagger::Operation do
  let(:source) do
    <<~RUBY
      class ThingsController
        #: -> void
        def undocumented; end

        # List things
        #
        # Returns every thing
        #: -> void
        def rbs_below_yard; end

        #: -> void

        # Show a thing
        #
        # Returns one thing
        def rbs_above_yard; end

        # Update a thing
        #
        # Changes one thing
        # @body_parameter [String] name The name
        #: (
        #|   Integer id
        #| ) -> void
        def rbs_multiline(id); end
      end
    RUBY
  end

  let(:tag) { Struct.new(:name, :controller_class).new('Things', 'ThingsController') }

  let(:original_ignore_rbs_comments) { Swaggard.configuration.ignore_rbs_comments }

  before do
    original_ignore_rbs_comments
    Swaggard.register_custom_yard_tags!
    ::YARD::Registry.clear
    ::YARD.parse_string(source)
  end

  after do
    ::YARD::Registry.clear
    Swaggard.configuration.ignore_rbs_comments = original_ignore_rbs_comments
  end

  def operation(name)
    yard_object = ::YARD::Registry.at("ThingsController##{name}")
    described_class.new(yard_object, tag, '/things', 'get', [])
  end

  it 'keeps RBS comments in the docs by default' do
    expect(Swaggard.configuration.ignore_rbs_comments).to be(false)
    expect(operation(:undocumented).summary).to eq(': -> void')
    expect(operation(:rbs_below_yard).description).to eq("Returns every thing\n: -> void")
  end

  context 'when ignore_rbs_comments is enabled' do
    before { Swaggard.configuration.ignore_rbs_comments = true }

    it 'treats an action documented only by an RBS comment as undocumented' do
      expect(operation(:undocumented)).to be_empty
    end

    it 'drops an RBS comment between the YARD block and the def' do
      op = operation(:rbs_below_yard)

      expect(op.summary).to eq('List things')
      expect(op.description).to eq('Returns every thing')
    end

    it 'leaves a YARD block below a detached RBS comment unchanged' do
      op = operation(:rbs_above_yard)

      expect(op.summary).to eq('Show a thing')
      expect(op.description).to eq('Returns one thing')
    end

    it 'drops a multi-line RBS signature and keeps the YARD tags' do
      op = operation(:rbs_multiline)

      expect(op.summary).to eq('Update a thing')
      expect(op.description).to eq('Changes one thing')
      body = op.definitions.fetch('ThingsController.rbs_multiline_body').to_doc({})
      expect(body['properties']).to eq('name' => { 'type' => 'string', 'description' => 'The name' })
    end
  end
end
