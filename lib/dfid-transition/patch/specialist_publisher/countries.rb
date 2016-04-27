require 'dfid-transition/patch/specialist_publisher/base'
require 'rest-client'
require 'govuk/registers/country'

module DfidTransition
  module Patch
    module SpecialistPublisher
      class Countries < Base
        def mutate_schema
          country_facet['allowed_values'] = transform_to_label_value(
            Govuk::Registers::Country.countries)
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
end
