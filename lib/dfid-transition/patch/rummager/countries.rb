require 'dfid-transition/patch/rummager/base'
require 'dfid-transition/transform/countries'

module DfidTransition
  module Patch
    module Rummager
      class Countries < Base
        include DfidTransition::Transform::Countries

        def mutate_schema
          add_country_to_fields
          add_countries_to_expansions
        end

        def add_countries_to_expansions
          schema_hash.fetch('expanded_search_result_fields')['country'] =
            transform_to_label_value(alphabetically_sorted_countries)
        end

        def add_country_to_fields
          unless schema_hash.fetch('fields').include?('country')
            schema_hash.fetch('fields') << 'country'
          end
        end
      end
    end
  end
end
