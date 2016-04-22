module DfidTransition
  class GovUkCountryRegister
    URL = 'https://country.register.gov.uk/records.json'.freeze

    def self.countries
      params = { 'page-size' => 100, 'page-index' => 1 }
      done = false

      existing_countries = -> (country) do
        country.dig('entry', 'end-date').nil?
      end

      [].tap do |results|
        while !done
          body = RestClient.get(URL, { params: params })
          countries_page = JSON.parse(body)

          results.concat(countries_page.select(&existing_countries))

          done = (countries_page.length < params['page-size'])
          params['page-index'] += 1
        end
      end
    end

  end
end
