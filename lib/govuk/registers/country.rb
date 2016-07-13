require 'rest-client'

module Govuk
  class Registers
    class Country
      URL = 'https://country.register.gov.uk/records.json?page-size=5000'.freeze

      def self.countries
        body = RestClient.get(URL)
        JSON.parse(body)
      end
    end
  end
end
