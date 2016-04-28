require 'dfid-transition/patch/rummager/base'
require 'govuk/registers/country'
require 'rest-client'

module DfidTransition
  module Patch
    module Rummager
      class Countries < Base
        def mutate_schema
          add_country_field
          add_search_terms
        end

      private

        def add_country_field
          schema_hash.fetch('fields') | ['country']
        end

        def add_search_terms
          schema_hash
            .fetch('expanded_search_result_fields')['country'] =
              transform_to_label_value(Govuk::Registers::Country.countries)
        end

        def transform_to_label_value(query_results)
          query_results.map do |result|
            {
              value: result.dig('entry', 'country'),
              label: result.dig('entry', 'name')
            }
          end
        end
      end
    end
  end
end
