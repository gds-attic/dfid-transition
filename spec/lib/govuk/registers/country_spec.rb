require 'spec_helper'
require 'rest-client'
require 'govuk/registers/country'

describe Govuk::Registers::Country do
  describe '.countries' do
    let(:query_results_p1)  { 'spec/fixtures/service-results/country-register-p1.json' }
    let(:query_results_p2)  { 'spec/fixtures/service-results/country-register-p2.json' }

    def page(index)
      { 'page-index' => index, 'page-size' => 100 }
    end

    it 'returns both active and inactive countries from the register' do
      allow(RestClient).to receive(:get).with(
        Govuk::Registers::Country::URL,
        params: page(1)).and_return(File.read(query_results_p1))
      allow(RestClient).to receive(:get).with(
        Govuk::Registers::Country::URL,
        params: page(2)).and_return(File.read(query_results_p2))

      result = Govuk::Registers::Country.countries

      expect(result.count).to eq 199
      expect(result).to include(
        "PT" => {
          "entry-number" => "147",
          "item-hash" => "sha-256:237f7100bbbdcf670f0b0087a07350cd824007e230795acef6835883a68f9a37",
          "entry-timestamp" => "2016-04-05T13:23:05Z",
          "name" => "Portugal",
          "country" => "PT",
          "citizen-names" => "Portuguese",
          "official-name" => "The Portuguese Republic"
        }
      )
      expect(result).to include(
        "SU" => {
          "entry-number" => "1",
          "item-hash" => "sha-256:e94c4a9ab00d951dadde848ee2c9fe51628b22ff2e0a88bff4cca6e4e6086d7a",
          "entry-timestamp" => "2016-04-05T13:23:05Z",
          "name" => "USSR",
          "country" => "SU",
          "end-date" => "1991-12-25",
          "citizen-names" => "Soviet citizen",
          "official-name" =>
          "Union of Soviet Socialist Republics"
        }
      )
    end
  end
end
