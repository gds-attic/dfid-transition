require 'spec_helper'
require 'json'
require 'dfid-transition/patch/rummager/countries'

describe DfidTransition::Patch::Rummager::Countries do
  it_behaves_like "a patcher"

  describe '#location' do
    context 'a location is not supplied' do
      it 'defaults to config/schemas/document_types/dfid_research_outputs.json relative to the current directory' do
        patcher = DfidTransition::Patch::Rummager::Countries.new(nil)

        expect(patcher.location).to eq(
          File.expand_path(
            File.join(
              Dir.pwd, '..', 'rummager/config/schema/document_types/dfid_research_output.json')))
      end
    end
  end

  describe '#run' do
    context 'the target schema file exists' do
      let(:schema_src) { 'spec/fixtures/schemas/rummager/dfid_research_outputs_src.json' }
      let(:patch_location) { 'spec/fixtures/schemas/rummager/dfid_research_outputs.json' }

      before do
        FileUtils.cp(schema_src, patch_location)
      end

      after do
        File.delete(patch_location)
      end

      it 'patches the schema with all of the country labels and values' do
        patcher = DfidTransition::Patch::Rummager::Countries.new(patch_location)

        patcher.run

        parsed_json = JSON.parse(File.read(patch_location))
        country_search_facets = parsed_json['expanded_search_result_fields']['country']

        expect(country_search_facets.count).to eq 199
        expect(country_search_facets).to include(
          'label' => 'Guinea-Bissau',
          'value' => 'GW'
        )
      end
    end
  end
end
