require 'spec_helper'
require 'dfid-transition/patch/govuk_content_schemas/countries'
require 'govuk/registers/country'

describe DfidTransition::Patch::GovukContentSchemas::Countries do
  let(:patch_location) { nil }
  subject(:patch) { DfidTransition::Patch::GovukContentSchemas::Countries.new(patch_location) }

  it_behaves_like "holds onto the location of a schema file and warns us if it is not there"

  describe '#location' do
    context 'a location is not supplied' do
      let(:patch_location) { nil }

      it 'defaults to govuk_content_schemas/formats/specialist_document/details.json relative to the current directory' do
        expect(patch.location).to eql(
          File.expand_path(
            '../govuk-content-schemas/formats/specialist_document/publisher/details.json',
            Dir.pwd
          )
        )
      end
    end
  end

  describe '#run' do
    let(:patch_location) { 'spec/fixtures/schemas/govuk_content_schemas/details.json' }

    before do
      allow(Govuk::Registers::Country).to receive(:countries).and_return(
        JSON.parse(File.read('spec/fixtures/service-results/country-records.json'))
      )

      FileUtils.cp(
        'spec/fixtures/schemas/govuk_content_schemas/details_src.json',
        patch_location)

      patch.run
    end

    after do
      File.delete(patch_location)
    end

    let(:schema) { JSON.parse(File.read(patch_location)) }

    subject(:countries) do
      schema.dig(*%w(definitions dfid_research_output_metadata properties country))
    end

    it 'is a multi-valued type' do
      expect(countries['type']).to eql('array')
    end

    describe 'the items' do
      subject(:items) { countries['items'] }

      it 'has a string type' do
        expect(items['type']).to eql('string')
      end

      it 'adds countries to the schema' do
        expect(items['enum'].count).to eq(196)
        expect(items['enum'].first).to eq('AF')
      end
    end
  end
end
