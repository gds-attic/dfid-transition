require 'spec_helper'
require 'dfid-transition/patch/govuk_content_schemas/themes'
require 'rdf/rdfxml'

describe DfidTransition::Patch::GovukContentSchemas::Themes do
  let(:patch_location) { nil }
  subject(:patch) { DfidTransition::Patch::GovukContentSchemas::Themes.new(patch_location) }

  it_behaves_like "holds onto the location of a schema file and warns us if it is not there"

  describe '#location' do
    context 'a location is not supplied' do
      let(:patch_location) { nil }

      it 'defaults to govuk_content_schemas/formats/specialist_document/details.json relative to the current directory' do
        expect(patch.location).to eql(
          File.expand_path(
            '../govuk-content-schemas/formats/specialist_document/publisher/details.json',
            Dir.pwd
          )
        )
      end
    end
  end

  describe '#run' do
    let(:patch_location) { 'spec/fixtures/schemas/govuk_content_schemas/details.json' }
    let(:r4d_skos_theme_repo) do
      RDF::Repository.load('spec/fixtures/service-results/r4d_skos_themes.rdf')
    end

    before do
      allow(patch).to receive(:themes_query).and_return(
        DfidTransition::Extract::Query::Themes.new(
          SPARQL::Client.new(r4d_skos_theme_repo)
        )
      )

      FileUtils.cp(
        'spec/fixtures/schemas/govuk_content_schemas/details_src.json',
        patch_location)

      patch.run
    end

    after do
      File.delete(patch_location)
    end

    let(:schema) { JSON.parse(File.read(patch_location)) }

    subject(:dfid_themes) do
      schema.dig(*%w(definitions dfid_research_output_metadata properties dfid_theme))
    end

    it 'is a multi-valued type' do
      expect(dfid_themes['type']).to eql('array')
    end

    describe 'the items' do
      subject(:items) { dfid_themes['items'] }

      it 'has a string type' do
        expect(items['type']).to eql('string')
      end

      it 'adds only top-level theme data to the schema' do
        expect(items['enum'].count).to eq(12)
      end

      it 'underscores/downcases values' do
        expect(items['enum']).to include('climate_and_environment')
      end
    end
  end
end
