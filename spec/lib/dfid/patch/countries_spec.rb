require 'spec_helper'
require 'json'
require 'dfid-transition/patch/countries'

describe DfidTransition::Patch::Countries do
  subject(:patch) { described_class.new(patch_location) }

  describe '#location' do
    context 'a schema location is supplied' do
      let(:patch_location) { 'spec/fixtures/patchme.json' }

      it 'patches that location' do
        expect(patch.location).to eq(patch_location)
      end
    end

    context 'a location is not supplied' do
      let(:patch_location) { nil }

      it 'defaults to lib/documents/schemas/dfid_research_outputs.json relative to the current directory' do
        expect(patch.location).to eq(
          File.expand_path(
            File.join(
              Dir.pwd, '..', 'specialist-publisher-rebuild/lib/documents/schemas/dfid_research_outputs.json')))
      end
    end
  end

  describe '#run' do
    let(:patch_location) { 'spec/fixtures/schemas/dfid_research_outputs.json' }

    context 'the target schema file does not exist' do
      it 'tells us so' do
        expect { patch.run }.to raise_error(
          Errno::ENOENT, /dfid_research_outputs\.json/)
      end
    end

    context 'the target schema file exists' do
      let(:schema_src) { 'spec/fixtures/schemas/dfid_research_outputs_src.json' }
      let(:query_results_p1)  { 'spec/fixtures/service-results/country-register-p1.json' }
      let(:query_results_p2)  { 'spec/fixtures/service-results/country-register-p2.json' }
      let(:parsed_json)    { JSON.parse(File.read(patch_location)) }
      let(:country_facet)  { parsed_json['facets'].find { |f| f['key'] == 'country' } }

      before do
        FileUtils.cp(schema_src, patch_location)
      end

      after do
        File.delete(patch_location)
      end

      context 'we have a full set of countries from the countries register' do
        def json_for_page(page)
          JSON.parse(
            File.read(
              "spec/fixtures/service-results/country-register-p#{page}.json"))
        end
        let(:all_countries) { json_for_page(1).concat(json_for_page(2)) }

        before do
          allow(Govuk::CountryRegister).to receive(:countries).
            and_return(all_countries)
        end

        it 'patches the schema with all extant countries' do
          patch.run
          expect(country_facet['allowed_values'].length).to eql(199)
          expect(country_facet['allowed_values']).to include(
            'label' => 'The Bahamas',
            'value' => 'BS'
          )
        end

        context 'the target schema file does not have a countries facet to patch' do
          let(:schema_src) { 'spec/fixtures/schemas/dfid_research_outputs_no_countries.json' }

          it 'fails with an informative KeyError' do
            expect { patch.run }.to raise_error(KeyError, /No country facet found/)
          end
        end
      end
    end
  end
end
