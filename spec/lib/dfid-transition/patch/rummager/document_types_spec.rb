require 'spec_helper'
require 'json'
require 'dfid-transition/patch/rummager/document_types'

describe DfidTransition::Patch::Rummager::DocumentTypes do
  subject(:patcher) { DfidTransition::Patch::Rummager::DocumentTypes.new(patch_location) }

  it_behaves_like 'holds onto the location of a schema file and warns us if it is not there'

  describe '#run' do
    include_examples 'fake document types'

    context 'the target schema file exists' do
      let(:schema_src)     { 'spec/fixtures/schemas/rummager/dfid_research_outputs_no_fields.json' }
      let(:patch_location) { 'spec/fixtures/schemas/rummager/dfid_research_outputs.json' }

      before do
        allow(patcher).to receive(:document_types_query).and_return(fake_document_types)

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
        type_expansions = parsed_json.dig('expanded_search_result_fields', 'dfid_document_type')
        expect(type_expansions).to include(
          'value' => 'book_chapter',
          'label' => 'Book Chapter'
        )
      end
    end
  end
end
