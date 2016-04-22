require 'rest-client'
require 'json'
require 'dfid-transition/patch/base'
require 'govuk/country_registry'

module DfidTransition
  module Patch
    class Countries < Base
      def mutate_schema
        country_facet['allowed_values'] = transform_to_label_value(
          Govuk::CountryRegister.countries)
      end

    private

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
