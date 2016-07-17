require 'spec_helper'
require 'dfid-transition/patch/govuk_content_schemas/document_types'
require 'rdf/rdfxml'

describe DfidTransition::Patch::GovukContentSchemas::DocumentTypes do
  let(:patch_location) { nil }
  subject(:patch) { DfidTransition::Patch::GovukContentSchemas::DocumentTypes.new(patch_location) }

  it_behaves_like 'holds onto the location of a schema file and warns us if it is not there'

  describe '#run' do
    include_examples 'fake document types'

    let(:patch_location) { 'spec/fixtures/schemas/govuk_content_schemas/details.json' }

    before do
      allow(patch).to receive(:document_types_query).and_return(fake_document_types)

      FileUtils.cp(
        'spec/fixtures/schemas/govuk_content_schemas/details_src.json',
        patch_location)

      patch.run
    end

    after do
      File.delete(patch_location)
    end

    let(:schema) { JSON.parse(File.read(patch_location)) }

    subject(:dfid_document_type) do
      schema.dig(*%w(definitions dfid_research_output_metadata properties dfid_document_type))
    end

    it 'is a single-valued type' do
      expect(dfid_document_type['type']).to eql('string')
    end

    describe 'the items' do
      subject(:items) { dfid_document_type['items'] }

      it 'has a string type' do
        expect(items['type']).to eql('string')
      end

      it 'adds document_types data to the schema' do
        expect(items['enum'].count).to eq(document_type_solutions.size)
      end

      it 'underscores/downcases values' do
        expect(items['enum']).to include('magazine_newsletter_newspaper_article')
      end
    end
  end
end
