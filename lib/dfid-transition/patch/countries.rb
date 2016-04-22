require 'rest-client'
require 'json'
require 'dfid-transition/patch/base'

module DfidTransition
  module Patch
    class Countries < Base
      REGISTER_JSON = 'https://country.register.gov.uk/records.json'

      def mutate_schema
        country_facet['allowed_values'] = transform_to_label_value(register_countries)
      end

    private

      ##
      # Get register-format country data
      def register_countries
        params = { 'page-size' => 100, 'page-index' => 1 }
        done = false

        existing_countries = -> (country) do
          country.dig('entry', 'end-date').nil?
        end

        [].tap do |results|
          while !done
            body = RestClient.get(REGISTER_JSON, params: params)
            countries_page = JSON.parse(body)

            results.concat(countries_page.select(&existing_countries))

            done = (countries_page.length < params['page-size'])
            params['page-index'] += 1
          end
        end
      end

      def transform_to_label_value(query_results)
        query_results.map do |result|
          {
            value: result.dig('entry', 'country'),
            label: result.dig('entry', 'name')
          }
        end
      end

      def country_facet
        facet('country')
      end
    end
  end
end
