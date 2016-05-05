require 'spec_helper'
require 'dfid-transition/patch/specialist_publisher/themes'

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
      expect(RDF::Repository).to receive(:load).and_return(r4d_skos_theme_repo)
      FileUtils.cp(
        'spec/fixtures/schemas/specialist_publisher/dfid_research_outputs_src.json',
        patch_location)
    end

    after do
      File.delete(patch_location)
    end

    it 'adds theme data to the schema' do

      patch.run

      schema = JSON.parse(File.read(patch_location))
      themes = schema['facets'].find { |facet| facet['key'] == 'theme' }
      allowed_values = themes['allowed_values']

      expect(allowed_values.count).to eq(95)
      expect(allowed_values).to include(
        'label' => 'Neglected Tropical Diseases',
        'value' => 'Neglected%20Tropical%20Diseases'
      )
    end

    it 'sorts themes alphabetically by label' do
      patch.run

      schema = JSON.parse(File.read(patch_location))
      themes = schema['facets'].find { |facet| facet['key'] == 'theme' }
      labels = themes['allowed_values'].map { |lv| lv['label'] }
      expect(labels).to eql(labels.sort), 'theme labels are not sorted'
    end
  end
end
