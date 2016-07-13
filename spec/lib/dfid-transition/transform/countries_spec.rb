require 'spec_helper'
require 'dfid-transition/transform/countries'
require 'govuk/registers/country'

describe DfidTransition::Transform::Countries do
  before do
    allow(Govuk::Registers::Country).to receive(:countries).and_return(
      JSON.parse(File.read('spec/fixtures/service-results/country-records.json')))
  end

  let(:test_object) do
    class TestObject
      include DfidTransition::Transform::Countries
    end

    TestObject.new
  end

  describe '#countries' do
    subject(:countries) { test_object.send :countries }

    it 'includes items like Portugal raw from the JSON' do
      expect(countries).to include(
        "PT" => {
          "entry-number" => "147",
          "entry-timestamp" => "2016-04-05T13:23:05Z",
          "item-hash" => "sha-256:237f7100bbbdcf670f0b0087a07350cd824007e230795acef6835883a68f9a37",
          "name" => "Portugal",
          "country" => "PT",
          "citizen-names" => "Portuguese",
          "official-name" => "The Portuguese Republic"
        }
      )
    end

    it 'fabricates the Cook Islands' do
      expect(countries).to include(
        "CK" => {
          "name" => "Cook Islands",
          "country" => "CK"
        }
      )
    end

    it 'renames "The Gambia" to "Gambia, The"' do
      expect(countries).to include(
        "GM" => {
          "entry-number" => "202",
          "entry-timestamp" => "2016-04-05T13:23:05Z",
          "item-hash" => "sha-256:dac66e05ee41707ff9115ed72705eaf8c2e0171285405bea9d859903e8f7ee40",
          "name" => "Gambia, The",
          "country" => "GM",
          "citizen-names" => "Gambian",
          "official-name" => "The Islamic Republic of The Gambia"
        }
      )
    end
    it 'renames "The Bahamas" to "Bahamas, The"' do
      expect(countries).to include(
        "BS" => {
          "entry-number" => "203",
          "entry-timestamp" => "2016-04-05T13:23:05Z",
          "item-hash" => "sha-256:a77f1e11270aab0c5bf315b2e7c268a7aff89713578020e1b4183c6df2b2c0e7",
          "name" => "Bahamas, The",
          "country" => "BS",
          "citizen-names" => "Bahamian",
          "official-name" => "The Commonwealth of The Bahamas"
        }
      )
    end

  end
end
