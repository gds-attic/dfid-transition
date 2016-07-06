require 'spec_helper'
require 'json'
require 'rdf/rdfxml'
require 'dfid-transition/patch/rummager/themes'

describe DfidTransition::Patch::Rummager::Themes do
  it_behaves_like "holds onto the location of a schema file and warns us if it is not there"

  subject(:patcher) { DfidTransition::Patch::Rummager::Themes.new(patch_location) }

  describe '#location' do
    context 'a location is not supplied' do
      let(:patch_location) { nil }

      it 'defaults to config/schemas/document_types/dfid_research_outputs.json relative to the current directory' do
        expect(patcher.location).to eq(
          File.expand_path(
            File.join(
              Dir.pwd, '..', 'rummager/config/schema/document_types/dfid_research_output.json')))
      end
    end
  end

  describe '#run' do
    context 'the target schema file exists' do
      let(:schema_src)     { 'spec/fixtures/schemas/rummager/dfid_research_outputs_no_fields.json' }
      let(:patch_location) { 'spec/fixtures/schemas/rummager/dfid_research_outputs.json' }
      let(:r4d_skos_theme_repo) do
        RDF::Repository.load('spec/fixtures/service-results/r4d_skos_themes.rdf')
      end

      before do
        allow(patcher).to receive(:themes_query).and_return(
          DfidTransition::Extract::Query::Themes.new(
            SPARQL::Client.new(r4d_skos_theme_repo)
          )
        )

        FileUtils.cp(schema_src, patch_location)

        patcher.run
      end

      after do
        File.delete(patch_location)
      end

      subject(:parsed_json) { JSON.parse(File.read(patch_location)) }

      it 'adds the theme field' do
        expect(parsed_json['fields']).to include('theme')
      end

      it 'patches the schema with all of the theme labels and values' do
        theme_expansions = parsed_json.dig('expanded_search_result_fields', 'theme')
        expect(theme_expansions).to include(
          'value' => 'climate_and_environment',
          'label' => 'Climate and Environment'
        )
      end
    end
  end
end
