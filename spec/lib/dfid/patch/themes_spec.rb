require 'spec_helper'
require 'dfid-transition/patch/themes'

describe DfidTransition::Patch::Themes do
  let(:path_to_schema) { nil }

  subject(:patch) { DfidTransition::Patch::Themes.new(path_to_schema) }

  describe '#location' do
    context 'a path is given' do
      let(:path_to_schema) { '/foo' }
      it 'stores the location of the schema' do
        expect(patch.location).to eq(path_to_schema)
      end
    end

    context 'when no path is given' do
      it 'derives a conventional location' do
        expect(patch.location).to eql(
          File.expand_path(
            File.join(Dir.pwd, '..',
              'specialist-publisher-rebuild/lib/documents/schemas/dfid_research_outputs.json')))
      end
    end
  end

  describe '#run' do
    let(:path_to_schema) { 'spec/fixtures/schemas/dfid_research_outputs.json' }
    let(:r4d_skos_theme_repo) do
      RDF::Repository.load('spec/fixtures/service-results/r4d_skos_themes.rdf')
    end

    before do
      FileUtils.cp(
        'spec/fixtures/schemas/dfid_research_outputs_src.json',
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
