require 'dfid-transition/transform/countries'
require 'dfid-transition/patch/specialist_publisher/base'
require 'rest-client'
require 'govuk/registers/country'

module DfidTransition
  module Patch
    module SpecialistPublisher
      class Countries < Base
        include DfidTransition::Transform::Countries

        def mutate_schema
          country_facet['allowed_values'] = transform_to_label_value(
            alphabetically_sorted_countries)
        end

      private

        def country_facet
          facet('country')
        end
      end
    end
  end
end
