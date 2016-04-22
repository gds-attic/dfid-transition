module Govuk
  class CountryRegister
    URL = 'https://country.register.gov.uk/records.json'.freeze

    def self.countries
      params = { 'page-size' => 100, 'page-index' => 1 }
      done = false

      [].tap do |results|
        while !done
          body = RestClient.get(URL, { params: params })
          countries_page = JSON.parse(body)

          results.concat(countries_page)

          done = (countries_page.length < params['page-size'])
          params['page-index'] += 1
        end
      end
    end

  end
end
