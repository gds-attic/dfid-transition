require 'spec_helper'
require 'dfid-transition/patch/specialist_publisher/themes'

describe DfidTransition::Patch::SpecialistPublisher::Themes do
  let(:path_to_schema) { nil }

  it_behaves_like "a patcher"

  describe '#run' do
    let(:path_to_schema) { 'spec/fixtures/schemas/specialist_publisher/dfid_research_outputs.json' }
    let(:r4d_skos_theme_repo) do
      RDF::Repository.load('spec/fixtures/service-results/r4d_skos_themes.rdf')
    end

    before do
      FileUtils.cp(
        'spec/fixtures/schemas/specialist_publisher/dfid_research_outputs_src.json',
        path_to_schema)
    end

    after do
      File.delete(path_to_schema)
    end

    it 'adds theme data to the schema' do
      expect(RDF::Repository).to receive(:load).and_return(r4d_skos_theme_repo)

      patch.run

      schema = JSON.parse(File.read(path_to_schema))
      themes = schema['facets'].find { |facet| facet['key'] == 'theme' }
      allowed_values = themes['allowed_values']

      expect(allowed_values.count).to eq(95)
      expect(allowed_values).to include(
        'label' => 'Neglected Tropical Diseases',
        'value' => 'Neglected%20Tropical%20Diseases'
      )
    end
  end
end
