require 'spec_helper'
require 'dfid-transition/govuk_country_registry'

describe DfidTransition::GovUkCountryRegister do
  describe '.countries' do
    let(:query_results_p1)  { 'spec/fixtures/service-results/country-register-p1.json' }
    let(:query_results_p2)  { 'spec/fixtures/service-results/country-register-p2.json' }

    def page(index)
      { 'page-index' => index, 'page-size' => 100 }
    end

    it 'returns both active and inactive countries from the register' do
      allow(RestClient).to receive(:get).with(
        DfidTransition::GovUkCountryRegister::URL,
        params: page(1)).and_return(File.read(query_results_p1))
      allow(RestClient).to receive(:get).with(
        DfidTransition::GovUkCountryRegister::URL,
        params: page(2)).and_return(File.read(query_results_p2))

      result = DfidTransition::GovUkCountryRegister.countries

      expect(result.count).to eq 199
      expect(result).to include("serial-number" => 204,
        "hash" => "a4290031913597e47cf38457798ec98ab977e745",
        "entry" =>
          {
            "citizen-names" => "Vatican citizen",
            "country" => "VA",
            "name" => "Vatican City",
            "official-name" => "Vatican City State"
          })
      expect(result).to include("serial-number" => 1,
        "hash"          => "439cf12ecb3f3cff67b8b5eab67aab4e28896941",
        "entry" => {
          "citizen-names" => "Soviet citizen",
          "country"       => "SU",
          "end-date"      => "1991-12-25",
          "name"          => "USSR",
          "official-name" => "Union of Soviet Socialist Republics"
        })
    end
  end
end
