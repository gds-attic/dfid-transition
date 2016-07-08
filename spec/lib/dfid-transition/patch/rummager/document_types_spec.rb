require 'spec_helper'
require 'json'
require 'rdf/rdfxml'
require 'dfid-transition/patch/rummager/document_types'

describe DfidTransition::Patch::Rummager::DocumentTypes do
  it_behaves_like "holds onto the location of a schema file and warns us if it is not there"

  subject(:patcher) { DfidTransition::Patch::Rummager::DocumentTypes.new(patch_location) }

  describe '#run' do
    context 'the target schema file exists' do
      let(:schema_src)     { 'spec/fixtures/schemas/rummager/dfid_research_outputs_no_fields.json' }
      let(:patch_location) { 'spec/fixtures/schemas/rummager/dfid_research_outputs.json' }
      let(:r4d_skos_document_type_repo) do
        RDF::Repository.load('spec/fixtures/service-results/r4d_skos_document_types.rdf')
      end

      before do
        allow(patcher).to receive(:document_types_query).and_return(
          DfidTransition::Extract::Query::DocumentTypes.new(
            SPARQL::Client.new(r4d_skos_document_type_repo)
          )
        )

        FileUtils.cp(schema_src, patch_location)

        patcher.run
      end

      after do
        File.delete(patch_location)
      end

      subject(:parsed_json) { JSON.parse(File.read(patch_location)) }

      it 'adds the document type field' do
        expect(parsed_json['fields']).to include('dfid_document_type')
      end

      it 'patches the schema with all of the theme labels and values' do
        theme_expansions = parsed_json.dig('expanded_search_result_fields', 'dfid_document_type')
        expect(theme_expansions).to include(
          'value' => 'magazine_newsletter_newspaper_article',
          'label' => 'Magazine/Newsletter/Newspaper Article'
        )
      end
    end
  end
end
