require 'spec_helper'
require 'json'
require 'dfid-transition/patch/rummager/themes'

describe DfidTransition::Patch::Rummager::Themes do
  it_behaves_like "holds onto the location of a schema file and warns us if it is not there"

  describe '#location' do
    context 'a location is not supplied' do
      it 'defaults to config/schemas/document_types/dfid_research_outputs.json relative to the current directory' do
        patcher = DfidTransition::Patch::Rummager::Themes.new(nil)

        expect(patcher.location).to eq(
          File.expand_path(
            File.join(
              Dir.pwd, '..', 'rummager/config/schema/document_types/dfid_research_output.json')))
      end
    end
  end

  describe '#run' do
    context 'the target schema file exists' do
      let(:schema_src) { 'spec/fixtures/schemas/rummager/dfid_research_outputs_no_fields.json' }
      let(:patch_location) { 'spec/fixtures/schemas/rummager/dfid_research_outputs.json' }

      before do
        FileUtils.cp(schema_src, patch_location)
      end

      after do
        File.delete(patch_location)
      end

      it 'patches the schema with all of the country labels and values' do
        patcher = DfidTransition::Patch::Rummager::Themes.new(patch_location)

        patcher.run

        parsed_json = JSON.parse(File.read(patch_location))
        expect(parsed_json['fields']).to include('theme')
      end
    end
  end
end
