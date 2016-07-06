require 'spec_helper'
require 'dfid-transition/patch/specialist_publisher/themes'
require 'rdf/rdfxml'

describe DfidTransition::Patch::SpecialistPublisher::Themes do
  let(:patch_location) { nil }
  subject(:patch) { DfidTransition::Patch::SpecialistPublisher::Themes.new(patch_location) }

  it_behaves_like "holds onto the location of a schema file and warns us if it is not there"

  describe '#run' do
    let(:patch_location) { 'spec/fixtures/schemas/specialist_publisher/dfid_research_outputs.json' }
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
        'spec/fixtures/schemas/specialist_publisher/dfid_research_outputs_src.json',
        patch_location)

      patch.run
    end

    after do
      File.delete(patch_location)
    end

    let(:schema) { JSON.parse(File.read(patch_location)) }
    let(:themes) { schema['facets'].find { |facet| facet['key'] == 'theme' } }

    subject(:allowed_values) { themes['allowed_values'] }

    it 'adds only top-level theme data to the schema' do
      expect(allowed_values.count).to eq(12)
    end

    it 'leaves labels alone and underscores/downcases values' do
      expect(allowed_values).to include(
        'label' => 'Climate and Environment',
        'value' => 'climate_and_environment'
      )
    end

    it 'sorts themes alphabetically by label' do
      labels = themes['allowed_values'].map { |lv| lv['label'] }
      expect(labels).to eql(labels.sort), 'theme labels are not sorted'
    end
  end
end
