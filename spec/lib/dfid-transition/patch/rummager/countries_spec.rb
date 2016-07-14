require 'spec_helper'
require 'json'
require 'dfid-transition/patch/rummager/countries'
require 'govuk/registers/country'

describe DfidTransition::Patch::Rummager::Countries do
  it_behaves_like "holds onto the location of a schema file and warns us if it is not there"

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
      let(:schema_src) { 'spec/fixtures/schemas/rummager/dfid_research_outputs_no_fields.json' }
      let(:patch_location) { 'spec/fixtures/schemas/rummager/dfid_research_outputs.json' }

      let(:patcher) { DfidTransition::Patch::Rummager::Countries.new(patch_location) }

      subject(:parsed_json) { JSON.parse(File.read(patch_location)) }

      before do
        FileUtils.cp(schema_src, patch_location)

        allow(Govuk::Registers::Country).to receive(:countries).and_return(
          JSON.parse(File.read('spec/fixtures/service-results/country-records.json')))

        patcher.run
      end

      after do
        File.delete(patch_location)
      end

      it 'adds the country field' do
        expect(parsed_json['fields']).to include('country')
      end

      it 'adds the field expansions' do
        countries = parsed_json.dig('expanded_search_result_fields', 'country')

        expect(countries).to be_an(Array)
        expect(countries.count).to eql(196)
        expect(countries).to include('value' => 'VA', 'label' => 'Vatican City')
      end
    end
  end
end
